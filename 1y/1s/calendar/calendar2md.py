import sys
import csv
from calendar import Calendar, monthcalendar, month_name, setfirstweekday
setfirstweekday(6) # Week starts at Sunday

def event_to_string(d,m,y) -> str :
    t = []
    if y in events and m in events[y] and d in events[y][m]:
        for l in events[y][m][d]:
            t.append('<br>'.join(l))
    return '<br>------<br>'.join(t)


def print_calendar():

    # Start calendar at : 
    start_year  = 2021
    start_month = 10

    # End calendar at :
    end_year  = 2022
    end_month = 2

    for y in range(start_year,end_year+1):
        for m in range(start_month if y == start_year else 1, end_month+1 if y == end_year else 13):
            print(f'# {month_name[m]} of {y}')
            print("|Sunday|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|")
            print("|:-:|:-:|:-:|:-:|:-:|:-:|:-:|")
            for w in monthcalendar(y,m): 
                for d in w:
                    print("|",end='')
                    if d > 0 :
                        print(f"{d}",end='')
                print("|")
                for d in w:
                    print("|",end='')
                    if d > 0 :
                        print(f"{event_to_string(d,m,y)}",end='')
                print("|")
            print("\n")


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

print_calendar()


