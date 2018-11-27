nomeMeios = ['Carro de Bombeiros', 'Mascaras de fumo', 'Paramedico', 'Ambulancia',
             'Helicoptero', 'Medico', 'Carro', 'Mangueira', 'Garrafas de agua',
             'Bombeiros', 'Drone', 'Desfibrilhador', 'Maca', 'Racoes', 'Esquadrao',
             'Kit de primeiros socorros', 'Psicologo', 'Camiao']
numMeioMin = 500
nomeEntidade = 'Bombeiros Municipais de Santa Comba Dao'
procsAccMeios = [  0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,
                  12,  13,  14,  15,  16,  17,  18,  19,  20,  21,  22,  23,
                  24,  25,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,
                  37,  38,  39,  40,  42,  43,  44,  47,  48,  49,  50,  51,
                  52,  53,  55,  56,  57,  58,  60,  61,  62,  63,  64,  65,
                  66,  67,  68,  69,  70,  71,  72,  73,  74,  75,  76,  77,
                  79,  80,  81,  82,  83,  84,  85,  86,  87,  88,  89,  90,
                  92,  93,  94,  95,  96,  97,  98,  99, 100, 101, 102, 103,
                 104, 106, 107, 108, 109, 110, 111, 112, 114, 115, 116, 117,
                 120, 121, 122, 124, 125, 126, 131, 132, 133, 134, 135, 136,
                 138, 140, 141, 142, 143, 144, 145, 148, 150, 151, 154, 156,
                 157, 159, 161, 163, 164, 166, 167, 168, 169, 170, 172, 173,
                 178, 181, 183, 184, 185, 187, 188, 190, 191, 192, 193, 194,
                 196, 197, 198, 201, 204, 210, 211, 214, 216, 218, 219, 220,
                 221, 223, 224, 227, 228, 229, 230, 231, 233, 234, 235, 236,
                 238, 240, 241, 248, 250, 251, 252, 253, 254, 255, 256, 257,
                 260, 263, 264, 268, 269, 270, 273, 276, 277, 279, 280, 285,
                 286, 287, 288, 291, 292, 293, 295, 298, 301, 304, 307, 311,
                 315, 316, 322, 323, 325, 330, 331, 335, 338, 340, 344, 351,
                 352, 359, 364, 371, 372, 376, 380, 383, 393, 395, 398, 400,
                 403, 405, 411, 413, 419, 422, 425, 429, 438, 441, 443, 449,
                 450, 481, 492]

nMeios = len(nomeMeios)
nProcs = len(procsAccMeios)

popfile = open('populate2.sql', 'a')
popfile.write('\n\n')

for i in range(nProcs):
    popfile.write("insert into Meio values (" + str(numMeioMin + i) + ", '" + nomeMeios[i % nMeios] + "', '" + nomeEntidade + "');\n")

popfile.write('\n')
for i in range(nProcs):
    popfile.write("insert into MeioCombate values (" + str(numMeioMin + i) + ", '" + nomeEntidade + "');\n")

popfile.write('\n')
for i in range(nProcs):
    popfile.write("insert into Acciona values (" + str(numMeioMin + i) + ", '" + nomeEntidade + "', " + str(procsAccMeios[i]) + ");\n")

popfile.close()