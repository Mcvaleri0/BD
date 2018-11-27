from random import *
import time

time_format = "'%Y-%m-%d %H:%M:%S'"

time_start = "'2018-01-01 00:00:00'"
time_end   = "'2018-11-24 23:59:59'"

numCamara = 0

moradas = ["Abrantes","Agualva-Cacém","Águeda","Albergaria-a-Velha","Albufeira",
            "Alcácer do Sal","Alcobaça","Alfena","Almada","Almeirim",
            "Alverca do Ribatejo","Amadora","Amarante","Amora","Anadia",
            "Angra do Heroísmo","Aveiro","Barcelos","Barreiro","Beja","Borba",
            "Braga","Bragança","Caldas da Rainha","Câmara de Lobos","Caniço",
            "Cantanhede","Cartaxo","Castelo Branco","Chaves","Coimbra",
            "Costa da Caparica","Covilhã","Elvas","Entroncamento","Ermesinde",
            "Esmoriz","Espinho","Esposende","Estarreja","Estremoz","Évora",
            "Fafe","Faro","Fátima","Felgueiras","Figueira da Foz","Fiães",
            "Freamunde","Funchal","Fundão","Gafanha da Nazaré","Gandra",
            "Gondomar","Gouveia","Guarda","Guimarães","Horta","Ílhavo","Lagoa",
            "Lagos","Lamego","Leiria","Lisboa","Lixa","Loulé","Loures",
            "Lourosa","Macedo de Cavaleiros","Machico","Maia","Mangualde",
            "Marco de Canaveses","Marinha Grande","Matosinhos","Mealhada",
            "Mêda","Miranda do Douro","Mirandela","Montemor-o-Novo","Montijo",
            "Moura","Odivelas","Olhão da Restauração","Oliveira de Azeméis",
            "Oliveira do Bairro","Oliveira do Hospital","Ourém","Ovar",
            "Paços de Ferreira","Paredes","Penafiel","Peniche","Peso da Régua",
            "Pinhel","Pombal","Ponta Delgada","Ponte de Sor","Portalegre",
            "Portimão","Porto","Póvoa de Santa Iria","Póvoa de Varzim",
            "Praia da Vitória","Quarteira","Queluz","Rebordosa",
            "Reguengos de Monsaraz","Ribeira Grande","Rio Maior",
            "Rio Tinto","Sabugal","Sacavém","Samora Correia","Santa Comba Dão",
            "Santa Cruz","Santa Maria da Feira","Santana","Santarém",
            "Santiago do Cacém","Santo Tirso","São João da Madeira",
            "São Mamede de Infesta","São Pedro do Sul","Lordelo","Seia",
            "Seixal","Senhora da Hora","Serpa","Setúbal","Silves","Sines",
            "Tarouca","Tavira","Tomar","Tondela","Torres Novas","Torres Vedras",
            "Trancoso","Trofa","Valbom","Vale de Cambra","Valença","Valongo",
            "Valpaços","Vendas Novas","Viana do Castelo","Vila Baleira",
            "Vila do Conde","Vila Franca de Xira","Vila Nova de Famalicão",
            "Vila Nova de Foz Côa","Vila Nova de Gaia",
            "Vila Nova de Santo André","Vila Real","Vila Real de Santo António",
            "Viseu","Vizela"]

moradas_ = moradas.copy()

numProcessoSocorro = 0

FirstNames = ["Manel", "Francisco", "Joana", "António", "Inês", "Rita", "Tiago",
              "Marta", "Pedro", "Catarina", "Carolina", "Daniel", "Miguel", "Ana",
              "João", "Cristiana"]

Surnames = ["Correia", "Nicolau", "Rodrigues", "Silva", "Margato", "Antunes", "Abreu",
            "Figueiredo", "Guerreiro", "Gômes", "Nogueira", "Coelho", "Matos",
            "Martinho", "Valério", "Vitorino"]

EntityTypes = ["Bombeiros Municipais", "Quartel", "Bombeiros Voluntários",
               "Esquadra", "Camara", "Fundação", "Junta", "Hospital"]

EntityNames = [""]

numMeio = 0

Battle = ["Helicoptero", "Mangueira", "Esquadrão", "Carro de Bombeiros",
          "Rações", "Mâscaras de fumo", "Bombeiros"]

Rescue = ["Helicoptero", "Camião", "Carro", "Ambulância", "Maca"]

Support = ["Desfibrilhador", "Psicólogo", "Paramédico", "Kit de primeiros socorros",
           "Drone", "Médico", "Garrafas de água"]

Mediums = [Battle, Rescue, Support]

procs = [None] * 333

coordenatorId = 0

def frm_num(num,l):
    res = str(num)

    while len(res) < l:
        res = "0" + res

    return res

def insert(table,columns,values):
    res = "insert into " + table + " "

    if(columns != []):
        res += "( "
        for cl in columns:
            res += cl + ", "
        res = res[:-2] + ") "

    res += "values"

    if(isinstance(values[0],list)):
        for vls in values:
            res += " ( "

            for vl in vls:
                res += str(vl) + ", "

            res = res[:-2] + "),"
        res = res[:-1]

    else:
        res += " ( "

        for vl in values:
            res += str(vl) + ", "

        res = res[:-2] + ")"

    return res + ";\n"

def genDate(start, end):
    st_time = time.mktime(time.strptime(start,time_format))
    en_time = time.mktime(time.strptime(end,time_format))

    rd_time = st_time + random() * (en_time - st_time)

    return time.strftime(time_format,time.localtime(rd_time))

def getEndDate(start,duration):
    st_time = time.mktime(time.strptime(start,time_format))
    en_time = st_time + duration

    return time.strftime(time_format, time.localtime(en_time))

def segmentVideo(start,total_d,n_cam):
    n_seg = 0;

    st_time = time.mktime(time.strptime(start,time_format))
    en_time = st_time + total_d

    sg = 1

    while(sg == 1 and en_time - st_time > 600):
        sg = randint(0,1)
        dr = randint(0,en_time - st_time)

        if(en_time - st_time - dr < 600):
            dr = en_time - st_time

        ppl.write(insert("SegmentoVideo", [], [n_seg, "'" + str(dr) + " seconds'",
                         "timestamp " + start, n_cam]))
        n_seg += 1

        st_time = st_time + dr

    if(st_time != en_time):
        ppl.write(insert("SegmentoVideo", [], [n_seg, "'" + str(int(en_time-st_time)) + " seconds'",
                        "timestamp " + start, n_cam]))

def genPhoneNumber():
    res = "'9";
    res += str(randint(1,6))

    for i in range(7):
        res += str(randint(0,9))

    return res + "'"

def genPersonName():
    return "'" + choice(FirstNames) + " " + choice(Surnames) + "'"

def genEntityName():
    tp = randint(0,1)
    res = ""
    global EntityNames

    while (res == "" or res in EntityNames):
        res = "'" + choice(EntityTypes)

        if  (tp == 0):
            res += " de " + choice(moradas)
        elif(tp == 1):
            res += " " + choice(FirstNames) + " " + choice(Surnames)

    EntityNames += [res]
    return res + "'"

def genMeio():
    tp = randint(0,2)
    return ["'" + choice(Mediums[tp]) + "'",tp]

def genAuditText():
    res = choice(["Com base na minha análise, ", "Acredito que ",
                  "Tendo concluido a minha auditoria, ", "Conclui que ",
                  "Estou convicto que "])

    res += choice(["todo o processo decorreu dentro da lei ",
                   "foram cortados cantos ",
                   "denota-se corrupção por parte de várias entidades ",
                   "foram realizados todos os possíveis para alcançar um boa resolução "])

    res += choice(["assim dou por concluida esta auditoria.",
                   "ainda, termino a auditoria convicto de que não são necessários mais procedimentos.",
                   "por fim deixo a indicação de que uma maior investigação será necessária."])

    return "'" + res + "'"

try:
    ppl = open("populate.sql",mode = 'x',encoding = 'utf-8')

    for ln in range(333):
        # Camara - numCamara
        ppl.write(insert("Camara", [], [numCamara]))
        numCamara += 1

        n_cam    = numCamara - 1
        duration = randint(0,24*60*60)
        st_date  = genDate(time_start,time_end)

        # Video - dataHoraInicio, dataHoraFim, numCamara
        ppl.write(insert("Video", [], ["timestamp " + st_date,"timestamp " + getEndDate(st_date,duration), n_cam]))

        # SegmentoVideo - numSegmento, duracao, dataHoraInicio, numCamara
        segmentVideo(st_date, duration, n_cam)

        # Local - moradaLocal
        morada = ""

        if(len(moradas_) != 0):
            morada = choice(moradas_)
            moradas_.remove(morada)
            morada = "'" + morada + "'"
            ppl.write(insert("Local", [], [morada]))

        if(morada == ""):
            morada = "'" + choice(moradas) + "'"

        # Vigia - moradaLocal, numCamara
        ppl.write(insert("Vigia", [], [morada,n_cam]))

        # ProcessoSocorro - numProcessoSocorro
        ppl.write(insert("ProcessoSocorro", [], [numProcessoSocorro]))

        #EventoEmergencia - numTelefone, instanteChamada, nomePessoa, moradaLocal, numProcessoSocorro
        callInstant = genDate(time_start,time_end)
        ppl.write(insert("EventoEmergencia", [],
        [genPhoneNumber(),"timestamp " + callInstant,
        genPersonName(), morada, numProcessoSocorro]))
        procs[numProcessoSocorro] = callInstant

        #EntidadeMeio - nomeEntidade
        entityName = genEntityName()
        ppl.write(insert("EntidadeMeio", [], [entityName]))

        #Meio - numMeio, nomeMeio, nomeEntidade
        medium_info = genMeio()
        medium = medium_info[0]
        medium_type = medium_info[1]
        proc = randint(0,numProcessoSocorro)
        ppl.write(insert("Meio", [], [numMeio, medium, entityName]))

        if  (medium_type == 0):
            #MeioCombate - numMeio, nomeEntidade
            ppl.write(insert("MeioCombate", [], [numMeio, entityName]))

        elif(medium_type == 1):
            #MeioApoio - numMeio, nomeEntidade
            ppl.write(insert("MeioApoio", [], [numMeio, entityName]))

            #Alocado - numMeio, nomeEntidade, numHoras, numProcessoSocorro
            ppl.write(insert("Alocado", [], [numMeio, entityName, "interval '" + str(randint(1,168)) + " hours'", proc]))

        elif(medium_type == 2):
            #MeioSocorro - numMeio, nomeEntidade
            ppl.write(insert("MeioSocorro", [], [numMeio, entityName]))

            #Transporta - numMeio, nomeEntidade, numVitimas, numProcessoSocorro
            ppl.write(insert("Transporta", [], [numMeio, entityName, randint(1,6), proc]))

        #Acciona - numMeio, nomeEntidade, numProcessoSocorro
        ppl.write(insert("Acciona", [], [numMeio, entityName, proc]))

        #Coordenador - idCoordenador
        ppl.write(insert("Coordenador", [], [coordenatorId]))

        #Audita idCoordenador, numMeio, nomeEntidade, numProcessoSocorro, dataHoraInicio, datahoraFim, dataAuditoria, texto
        if(randint(0,1) == 1):
            auditStart = genDate(procs[proc],time_end)
            auditDate  = auditStart.split()[0]
            auditEnd   = genDate(auditStart,time_end)
            ppl.write(insert("Audita", [], [coordenatorId, numMeio, entityName,
                             proc, "timestamp " + auditStart, "timestamp " + auditEnd,
                             "date " + auditDate + "'", genAuditText()]))

            #Solicita idCoordenador, dataHoraInicioVideo, numCamara, dataHoraInicio, dataHoraFim
            sol_start = genDate(auditStart,auditEnd)
            sol_end   = genDate(sol_start,auditEnd)
            ppl.write(insert("Solicita", [], [coordenatorId, "timestamp " + st_date,
                             n_cam, "timestamp " + sol_start, "timestamp " + sol_end]))

        numProcessoSocorro += 1
        numMeio += 1
        coordenatorId += 1
finally:
    ppl.close()
