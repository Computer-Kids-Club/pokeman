from urllib.request import Request, urlopen
import json

def getSec(s,b,e):
    try:
        s = s[s.index(b)+len(b):]
        return s[:s.index(e)]
    except:
        return 'error'

req = Request('https://pokemondb.net/pokedex/all', headers={'User-Agent': 'Mozilla/5.0'})
data = urlopen(req).read().decode('utf-8')

print(len(data))

poke_all_data = data[data.index("</thead>"):data.index('</table>')]

poke_list_data = poke_all_data.split('</tr>')

idx = 0

sts = []

for poke_data in poke_list_data:

    poke_num = getSec(poke_data,'></i> ','</td>')

    poke_name = getSec(poke_data,'<a class="ent-name" href="/pokedex/','" title=')

    if poke_name not in sts:
        sts.append(poke_name)

    file = open("pokeinfo/pokemon/"+str(int(poke_num))+".txt","w")

    poke_dict = {}

    poke_dict["number"] = poke_num
    poke_dict["name"] = poke_name
    
    poke_dict["gif"] = "http://play.pokemonshowdown.com/sprites/xyani/" + poke_name + ".gif"
    poke_dict["gifb"] = "http://play.pokemonshowdown.com/sprites/xyani-back/" + poke_name + ".gif"
    poke_dict["gifs"] = "http://play.pokemonshowdown.com/sprites/xyani-shiny/" + poke_name + ".gif"
    poke_dict["gifbs"] = "http://play.pokemonshowdown.com/sprites/xyani-back-shiny/" + poke_name + ".gif"

    if poke_name == "nidoran-f":
        poke_dict["gif"] = "http://play.pokemonshowdown.com/sprites/xyani/nidoranf.gif"
        poke_dict["gifb"] = "http://play.pokemonshowdown.com/sprites/xyani-back/nidoranf.gif"
        poke_dict["gifs"] = "http://play.pokemonshowdown.com/sprites/xyani-shiny/nidoranf.gif"
        poke_dict["gifbs"] = "http://play.pokemonshowdown.com/sprites/xyani-back-shiny/nidoranf.gif"
    if poke_name == "nidoran-m":
        poke_dict["gif"] = "http://play.pokemonshowdown.com/sprites/xyani/nidoran.gif"
        poke_dict["gifb"] = "http://play.pokemonshowdown.com/sprites/xyani-back/nidoranm.gif"
        poke_dict["gifs"] = "http://play.pokemonshowdown.com/sprites/xyani-shiny/nidoranm.gif"
        poke_dict["gifbs"] = "http://play.pokemonshowdown.com/sprites/xyani-back-shiny/nidoranm.gif"
    if poke_name == "mr-mime":
        poke_dict["gif"] = "http://play.pokemonshowdown.com/sprites/xyani/mrmime.gif"
        poke_dict["gifb"] = "http://play.pokemonshowdown.com/sprites/xyani-back/mrmime.gif"
        poke_dict["gifs"] = "http://play.pokemonshowdown.com/sprites/xyani-shiny/mrmime.gif"
        poke_dict["gifbs"] = "http://play.pokemonshowdown.com/sprites/xyani-back-shiny/mrmime.gif"

    curr_poke_data = urlopen(Request('https://pokemondb.net/pokedex/'+poke_name, headers={'User-Agent': 'Mozilla/5.0'})).read().decode('utf-8')

    curr_poke_data = curr_poke_data.replace("\n","")
    curr_poke_data = curr_poke_data.replace("> <","><")
    curr_poke_data = curr_poke_data.replace("&#8242;","'")
    curr_poke_data = curr_poke_data.replace("&#8243;",'"')
    #print(curr_poke_data)

    types_data = getSec(curr_poke_data,'<th>Type</th><td>','</td>')

    types_data_sep = types_data.split("</a>")

    poke_dict["type1"] = getSec(types_data_sep[0],'/type/','"')

    if len(types_data_sep) >= 3:
        poke_dict["type2"] = getSec(types_data_sep[1],'/type/','"')

    poke_dict["species"] = getSec(curr_poke_data,'<th>Species</th><td>','</td>')
    poke_dict["height"] = getSec(curr_poke_data,'<th>Height</th><td>','</td>')
    poke_dict["weight"] = getSec(curr_poke_data,'<th>Weight</th><td>','</td>')
    abilities_data = getSec(curr_poke_data,'<th>Abilities</th><td>','</td>')

    abilities_data_sep = abilities_data.split("<br>")

    poke_dict["ability1"] = getSec(abilities_data_sep[0],'/ability/','"')

    if len(abilities_data_sep) >= 4:
        poke_dict["ability2"] = getSec(abilities_data_sep[1],'/ability/','"')

    if len(abilities_data_sep) >= 3:
        poke_dict["hiddenability"] = getSec(abilities_data_sep[-2],'/ability/','"')
        
        
    poke_dict["evyield"] = getSec(curr_poke_data,'<th>EV yield</th><td class="text">','</td>')
    poke_dict["catchrate"] = getSec(curr_poke_data,'<th>Catch rate</th><td>',' <small')
    poke_dict["basehappy"] = getSec(curr_poke_data,'<th>Base Happiness</th><td>',' <small')
    poke_dict["baseexp"] = getSec(curr_poke_data,'<th>Base EXP</th><td>','</td>')
    poke_dict["growthrate"] = getSec(curr_poke_data,'<th>Growth Rate</th><td>','</td>')

    poke_dict["HP"]  = (getSec(curr_poke_data,'<th>HP</th><td class="num">','</td>'))
    poke_dict["ATK"] = (getSec(curr_poke_data,'<th>Attack</th><td class="num">','</td>'))
    poke_dict["DEF"] = (getSec(curr_poke_data,'<th>Defense</th><td class="num">','</td>'))
    poke_dict["SPA"] = (getSec(curr_poke_data,'<th>Sp. Atk</th><td class="num">','</td>'))
    poke_dict["SPD"] = (getSec(curr_poke_data,'<th>Sp. Def</th><td class="num">','</td>'))
    poke_dict["SPE"] = (getSec(curr_poke_data,'<th>Speed</th><td class="num">','</td>'))

    level_moves = getSec(getSec(curr_poke_data,"<h3>Moves learnt by level up</h3>","<h3>Egg moves</h3>"),"</tr></thead><tbody>","</tr></tbody>").split("</tr>")
    egg_moves = getSec(getSec(curr_poke_data,"<h3>Egg moves</h3>","<h3>Move Tutor moves</h3>"),"</tr></thead><tbody>","</tr></tbody>").split("</tr>")
    tutor_moves = getSec(getSec(curr_poke_data,"<h3>Move Tutor moves</h3>","<h3>Moves learnt by TM</h3>"),"</tr></thead><tbody>","</tr></tbody>").split("</tr>")
    tm_moves = getSec(getSec(curr_poke_data,"<h3>Moves learnt by TM</h3>","In other generations:"),"</tr></thead><tbody>","</tr></tbody>").split("</tr>")

    poke_dict["levelmoves"] = []
    for move in level_moves:
        curr_move = {}
        curr_move["move"] = getSec(move,'/move/','"')
        curr_move["lv"] = getSec(move,'class="num">','<')
        curr_move["type"] = getSec(move,'/type/','"')
        poke_dict["levelmoves"].append(curr_move)

    poke_dict["eggmoves"] = []
    for move in egg_moves:
        curr_move = {}
        curr_move["move"] = getSec(move,'/move/','"')
        curr_move["type"] = getSec(move,'/type/','"')
        poke_dict["eggmoves"].append(curr_move)

    poke_dict["tutormoves"] = []
    for move in tutor_moves:
        curr_move = {}
        curr_move["move"] = getSec(move,'/move/','"')
        curr_move["type"] = getSec(move,'/type/','"')
        poke_dict["tutormoves"].append(curr_move)

    poke_dict["tmmoves"] = []
    for move in tm_moves:
        curr_move = {}
        curr_move["move"] = getSec(move,'/move/','"')
        curr_move["type"] = getSec(move,'/type/','"')
        poke_dict["tmmoves"].append(curr_move)
    
    file.write(json.dumps(poke_dict))

    file.close()
        
    if poke_num == '807':
        break

#sts = list(set(sts))

#print('","'.join(sts))
print(len(sts))
