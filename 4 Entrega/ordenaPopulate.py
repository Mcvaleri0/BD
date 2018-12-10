tabelas = ['Camara', 'Local', 'EntidadeMeio', 'Coordenador', 'Video', 'SegmentoVideo',
           'ProcessoSocorro', 'Meio', 'MeioCombate', 'MeioApoio', 'MeioSocorro',
           'Vigia', 'EventoEmergencia', 'Transporta', 'Alocado', 'Acciona', 'Audita',
           'Solicita']

popfile = open('populate.sql', 'r')
poplines = popfile.readlines()
popfile.close()

nLinhas = len(poplines)

pop2file = open('populate2.sql', 'w')

for t in tabelas:
    pop2file.write("start transaction;\n\n")
    
    for i in range(nLinhas):
        line = poplines[i].split(' ')
        
        if line[2] == t:
            line_size = len(line)
            
            pop2file.write(line[0])
            for j in range(1, line_size):
                pop2file.write(' ' + line[j])
                
    pop2file.write('\n')

pop2file.write("\ncommit;")

pop2file.close()
