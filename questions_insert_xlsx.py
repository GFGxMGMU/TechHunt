import psycopg2
import pandas as pd

data = []

def validate(row):
    qno, que, o1, o2, o3, o4, corr, round = row
    try:
        qno, corr, round = [int(i) for i in [qno, corr, round]]
    except:
        return False
    if "" in [que, o1, o2, o3, o4]:
        return False
    if qno < 1 or not ( 1 <= corr <= 4) or not (1 <= round <= 5):
        return False
    return True

import pandas as pd

# Read the Excel file using pandas
data = pd.read_excel("questions.xlsx")

# Iterate over rows using iterrows()
for index, row in data.iterrows():
    try:
        # Assuming 'validate' is a function that checks the validity of the row
        if not validate(row):
            print(f"Jhol at row: {row}")
            break
    except Exception as s:
        print(f"jhol at row {row}", s, len(row))
        break


#[print(i) for i in data]
conn = psycopg2.connect("postgres://postgres:postpostgresgres@localhost:5432/gfghunt_nakli")
cur = conn.cursor()
for row in data:
    cur.execute("insert into questions(question, option1, option2, option3, option4, correct, round_num) values (%s, %s, %s, %s, %s, %s, %s)", tuple([str(i) for i in row[1:]]))

conn.commit()
cur.close()
conn.close()
