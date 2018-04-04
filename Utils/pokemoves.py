from urllib.request import Request, urlopen
import json

def getSec(s,b,e):
    try:
        s = s[s.index(b)+len(b):]
        return s[:s.index(e)]
    except:
        return 'error'

req = Request('https://pokemondb.net/move/all', headers={'User-Agent': 'Mozilla/5.0'})
data = urlopen(req).read().decode('utf-8')

print(len(data))

poke_all_data = data[data.index("</thead>"):data.index('</table>')]

poke_list_data = poke_all_data.split('</tr>')

sts = []

for poke_data in poke_list_data:

    poke_data = poke_data.replace("\n","")
    poke_data = poke_data.replace("> <","><")
    poke_data = poke_data.replace("\u2014","-")

    poke_name = getSec(poke_data,'/move/','"')

    if poke_name not in sts:
        sts.append(poke_name)

    sts.append(poke_name)

    file = open("pokeinfo/move/"+poke_name+".txt","w")

    poke_dict = {}

    move_stats = poke_data.split("td class");
    
    poke_dict["name"] = poke_name
    poke_dict["type"] = getSec(poke_data,'/type/','"')
    poke_dict["cat"] = getSec(poke_data,'/images/icons/','.png')
    
    poke_dict["power"] = getSec(move_stats[4],'"num">','<')
    poke_dict["acc"] = getSec(move_stats[5],'"num">','<')
    poke_dict["pp"] = getSec(move_stats[6],'"num">','<')

    poke_dict["effect"] = getSec(poke_data,'"long-text">','<')    
    poke_dict["prob"] = getSec(move_stats[9],'"num">','<')
    
    file.write(json.dumps(poke_dict))

    file.close()
        
    if poke_name == 'zing-zap':
        break

#sts = list(set(sts))

#print('","'.join(sts))
print(len(sts))
