from sqlalchemy import create_engine
import pandas as pd

engine= create_engine("mysql+mysqldb://root:root@localhost/coffee_shop")
conn=engine.connect()
data=pd.read_csv("D:/Naresh_IT/CampusX/Data Analyst/Coffee Shop/coffee_Shop_sales.csv")
data.to_sql('coffee_sales', engine,index=False, if_exists='replace')
conn.close()