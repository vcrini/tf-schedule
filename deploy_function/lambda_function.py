import json
import pymysql
import boto3
import os

endpoint = os.getenv('ENDPOINT')
port = int(os.getenv('PORT'))
dbname = os.getenv('DBNAME')
user = os.getenv('USER')
query = os.getenv('QUERY')
region = os.getenv('REGION')
secret_name = os.getenv('SECRET_NAME')


def handler(event, context):
    print("incoming event:" + json.dumps(event))
    session = boto3.session.Session()
    client = session.client('ssm')
    response = client.get_parameter(Name=secret_name)
    passwd = response["Parameter"]["Value"]
    params = {"endpoint": endpoint, "user": user, "port": port, "database": dbname, "query": query}
    try:
        print(params)
        conn = pymysql.connect(host=params["endpoint"], user=params["user"], passwd=passwd, port=params["port"], db=params["database"])
        cur = conn.cursor()
        for q in params["query"].split(";"):
            print(q)
            cur.execute(q)
            query_results = cur.fetchall()
            print(query_results)
    except Exception as e:
        print("Database connection failed due to {}".format(e))
        return event
