import sys
import csv
from calendar import Calendar, monthcalendar, month_name
c = Calendar(6) # 6 : week starts at Sunday

def event_to_string(d,m,y) -> str :
    t = []
    if y in events and m in events[y] and d in events[y][m]:
        for l in events[y][m][d]:
            t.append('<br>'.join(l))
    return '<br>------<br>'.join(t)


def save_calendar( ofile : str):

    # Start calendar at : 
    start_year  = 2021
    start_month = 10

    # End calendar at :
    end_year  = 2022
    end_month = 2

    # Open file
    out = open(ofile, "w")

    for y in range(start_year,end_year+1):
        for m in range(start_month if y == start_year else 1, end_month+1 if y == end_year else 13):
            out.write(f'# {month_name[m]} of {y}\n')
            out.write("|Sunday|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|\n")
            out.write("|:-:|:-:|:-:|:-:|:-:|:-:|:-:|\n")
            for w in monthcalendar(y,m): 
                for d in w:
                    out.write("|")
                    if d > 0 :
                        out.write(f"{d}")
                out.write("|\n")
                for d in w:
                    out.write("|")
                    if d > 0 :
                        e = event_to_string(d,m,y)
                        print(e)
                        print(f'{d}-{m}-{y} : {e}')
                        out.write(f"{e}")
                out.write("|\n")
            out.write("\n\n")

    out.close()


# MAIN CODE

events = {}

"""
Import dataset to Dic
"""
with open(sys.argv[1], newline='') as entry_file:
     reader = csv.reader(entry_file)
     entries = list(reader)

"""
CSV file should be:

date1,info1,info2,...
date2,info3,info4,...

if dates coincide, separate with \n----\n
for entries with multiple info, separate with \n  

""" 

for entry in entries:
    [d,m,y] = map(int,entry[0].split('-'))
    events.setdefault(y,{}).setdefault(m,{}).setdefault(d,[]).append(entry[1:])

save_calendar(sys.argv[2])


