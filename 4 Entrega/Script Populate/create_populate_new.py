from random import randint


def insert(table, values):
    global ppl

    s = "insert into " + table + " values ("

    for v in values:
        s += v + ", "

    s = s[:-2]
    s += ");\n"

    ppl.write(s)


def getTime():
    global t
    t += 1
    return "timestamp '2018-12-1 0:0:0' + interval '" + str(t) + " seconds'"


def getPhone():
    return "'" + str(900000000 + randint(0, 99999999)) + "'"


t = 0
ppl = open("new.sql", "a")

for i in range(10000, 20000, 1):
    I = str(i)

    insert("Camara", [I])
    insert("Video", [getTime(), getTime(), I])

    insert("Local", ["'Local " + I + "'"])
    insert("Vigia", ["'Local " + I + "'", I])

    insert("EntidadeMeio", ["'Entidade " + I + "'"])
    insert("Meio", [I, "'Meio " + I + "'", "'Entidade " + I + "'"])
    insert("MeioSocorro", [I, "'Entidade " + I + "'"])
    insert("ProcessoSocorro", [I])
    insert("EventoEmergencia", [getPhone(), getTime(), "'Pessoa " + I + "'",
                                "'Local " + I + "'", I])
    insert("Transporta", [I, "'Entidade " + I + "'", I, I])


ppl.close()
