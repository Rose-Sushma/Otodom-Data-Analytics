create database demo;
create warehouse demo_wh;

use demo;


---------------------------------------------------
       LOAD CSV to SNOWFLAKE - ADDRESS TABLE
---------------------------------------------------


1) Create the destination table:

CREATE or replace TABLE OTODOM_DATA_ADDRESS
(
    rn   int,
    location  text,
    address  text
);



2) Create a file format object for CSV file:

CREATE OR REPLACE FILE FORMAT CSV_FORMAT
  type = csv
  field_delimiter = ','
  field_optionally_enclosed_by='"';



3) Create an internal stage:

 CREATE OR REPLACE STAGE MY_CSV_STAGE
  file_format=csv_format;


  snowsql -a xxteigg-yz64007 -u thoufiq


4) Load csv file data to internal stage. Please note, below PUT command can only be run from SNOWSQL (Command line prompt os Snowflake).

PUT file:your_path @my_csv_stage;

5) Load data from stage to table:

COPY INTO OTODOM_DATA_ADDRESS
from @my_csv_stage;




6) Verify the data:

SELECT * FROM OTODOM_DATA_ADDRESS order by rn;





---------------------------------------------------
       LOAD CSV to SNOWFLAKE - TRANSLATE TABLE
---------------------------------------------------

CREATE or replace TABLE OTODOM_DATA_TRANSLATE
(
    rn   int,
    title  text,
    title_eng  text
);


CREATE OR REPLACE STAGE MY_CSV_STAGE_TRANS
  file_format=csv_format;

PUT file:your_path @MY_CSV_STAGE_TRANS;

COPY INTO OTODOM_DATA_TRANSLATE
from @MY_CSV_STAGE_TRANS;


SELECT * FROM OTODOM_DATA_TRANSLATE;




---------------------------------------------------
       LOAD CSV to SNOWFLAKE - FLATTEN TABLE
---------------------------------------------------

CREATE or replace TABLE OTODOM_DATA
(
    RN   int,
    ADVERTISER_TYPE  text,
    BALCONY_GARDEN_TERRACE  text,
    DESCRIPTION  text,
    HEATING  text,
    IS_FOR_SALE	  text,
    LIGHTING  text,
    LOCATION  text,
    PRICE  text,
    REMOTE_SUPPORT  text,
    RENT_SALE  text,
    SURFACE  text,
    TIMESTAMP  text,
    TITLE  text,
    URL  text,
    FORM_OF_PROPERTY  text,
    NO_OF_ROOMS  text,
    PARKING_SPACE  text
);




CREATE OR REPLACE STAGE MY_CSV_STAGE_ORG
  file_format=csv_format;

PUT file:your_path @MY_CSV_STAGE_ORG;

COPY INTO OTODOM_DATA
from @MY_CSV_STAGE_ORG;



SELECT count(1) FROM OTODOM_DATA_ADDRESS; -- 62,802
SELECT count(1) FROM OTODOM_DATA_TRANSLATE; -- 62,802
SELECT count(1) FROM OTODOM_DATA; -- 62,802

SELECT * FROM OTODOM_DATA_ADDRESS; 
SELECT * FROM OTODOM_DATA_TRANSLATE; 
SELECT * FROM OTODOM_DATA;


CREATE OR REPLACE TABLE OTODOM_DATA_TRANSFORMED
as
with cte as 
    (select ot.*
    , case when price like 'PLN%' then try_to_number(replace(price,'PLN ',''),'999,999,999.99')
           when price like '€%' then try_to_number(replace(price,'€',''),'999,999,999.99') * 4.43
      end as price_new
    , try_to_double(replace(replace(replace(replace(surface,'m²',''),'м²',''),' ',''),',','.'),'9999.99') as surface_new
    , replace(parse_json(addr.address):suburb,'"', '') as suburb
    , replace(parse_json(addr.address):city,'"', '') as city
    , replace(parse_json(addr.address):country,'"', '') as country
    , trans.title_eng as title_eng
    from OTODOM_DATA ot 
    left join otodom_data_address addr on ot.rn=addr.rn 
    left join otodom_data_translate trans on ot.rn=trans.rn)
select *
, case when lower(title_eng) like '%commercial%' or lower(title_eng) like '%office%' or lower(title_eng) like '%shop%' then 'non apartment'
       when lower(is_for_sale) = 'false' and surface_new <=330 and price_new <=55000 then 'apartment'
       when lower(is_for_sale) = 'false' then 'non apartment'
       when lower(is_for_sale) = 'true'  and surface_new <=600 and price_new <=20000000 then 'apartment'
       when lower(is_for_sale) = 'true'  then 'non apartment'
  end as apartment_flag
from cte;



select count(1) from OTODOM_DATA_TRANSFORMED;
select * from OTODOM_DATA_TRANSFORMED;






