import operator

print ",".join(["state", "renew", "total", "fraction", "percentile"])
raw = {}
data = {}
for line in open('renew_cm_state.csv').readlines():
    line = line.rstrip()
    parts = line.split(",")
    if "RETCB" in line:
        renew = float(parts[2])
    elif "TETCB" in line:
        total = float(parts[2])
        state = parts[0].replace('"', '')
        fraction = renew / float(total)
        data[state] = [state, renew, total, fraction]
        raw[state] = fraction

sorted_x = sorted(raw.iteritems(), key=operator.itemgetter(1))
pct = {}
for i in range(len(sorted_x)):
    pct[sorted_x[i][0]] = i / float(len(sorted_x))

for state in data.keys():
    print ",".join([str(x) for x in data[state] + [pct[state]]])
