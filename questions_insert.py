import psycopg2
import csv

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

with open("questions.tsv") as f:
    c = csv.reader(f, delimiter='	', dialect='excel')
    for row in c:
        data.append(row)
        try:
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
