tabelas = ['Camara', 'Local', 'EntidadeMeio', 'Coordenador', 'Video', 'SegmentoVideo',
           'ProcessoSocorro', 'Meio', 'MeioCombate', 'MeioApoio', 'MeioSocorro',
           'Vigia', 'EventoEmergencia', 'Transporta', 'Alocado', 'Acciona', 'Audita',
           'Solicita']

popfile = open('new.sql', 'r')
poplines = popfile.readlines()
popfile.close()

nLinhas = len(poplines)

for t in tabelas:
    if t == 'EventoEmergencia':
        pop2file = open('ProcessoSocorro.sql', 'a')
    else:
        pop2file = open(t + '.sql', 'w')
        pop2file.write("start transaction;\n\n")

    for i in range(nLinhas):
        line = poplines[i].split(' ')

        if line[2] == t:
            line_size = len(line)

            pop2file.write(line[0])
            for j in range(1, line_size):
                pop2file.write(' ' + line[j])
                
    pop2file.write('\n')

    if t != 'ProcessoSocorro':
        pop2file.write("commit;")

    pop2file.close()
