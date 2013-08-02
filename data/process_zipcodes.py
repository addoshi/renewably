print ",".join(['zipcode', 'state_abbr'])
for line in open('free-zipcode-database-Primary.csv', 'r').readlines():
    line = line.rstrip()
    parts = [x.replace('"', '') for x in line.split(",")]
    if parts[0] == "Zipcode":
        continue
    zip = parts[0]
    state = parts[3]
    print ",".join([zip, state])
    
    
