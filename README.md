# Otodom-Data-Analytics
Otodom – internet advertising service regarding real estate, operating in Poland since 2006. Otodom allows users to view and post ads for the sale and rental of real estate: apartments, houses, rooms, plots, commercial premises, halls, warehouses and garages.


Prerequisites. 
1. Install the below libraries
    -pip install pandas
    -pip install SQLAlchemy
    -pip install "snowflake-connector-python[pandas]"
    -pip install snowflake-sqlalchemy
    -pip install matplotlib
    -pip install jupyterlab
    -pip install notebook
2. Otodom dataset.
3. create an snowfloke account and load the otodom data into tables(https://github.com/Rose-Sushma/Otodom-Data-Analytics/blob/main/Snowflake_Data_Load_Git.sql).

Below are the probelm statements solved and reports were genertor so far(https://github.com/Rose-Sushma/Otodom-Data-Analytics/blob/main/Otodom_Project.ipynb):

1. What is the average rental price of 1 room, 2 room, 3 room and 4 room apartments in some of the major cities in Poland? 
	Arrange the result such that avg rent for each type fo room is shown in seperate column.
2. if a customer want buy an apartment which is around 90-100 m2 and within a range of 800,000 to 1M, display the suburbs in warsaw where they can find such apartments.
