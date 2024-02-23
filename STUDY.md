# STUDY GUIDE

https://teardowngame.com/modding/
https://teardowngame.com/modding/api.html
https://www.teardowngame.com/modding/voxscript.html
https://teardowngame.com/modding/api.html
https://github.com/Autumnagnificent/Teardown-Totally-Documented/blob/main/Community%20Resource%20Bundles/Shape%20Utils/shape_utils.lua

### SKYBOX

```
Custom skybox
To create a custom skybox for Teardown download this tool (https://www.teardowngame.com/modding/downloadable/skybox-dds.zip) and follow the instructions in readme.txt."
```
place in your mods folder and then in enviroment node (in editor) type: skybox=MOD/my_skybox.dds

---
### TICK() - Callback function

```
function tick()
    /.../
end
```

Tick fornece o tempo passado em segundos desde 1 de janeiro de 1970.
É muito usada para contar quantos segundos para calcular quantos segundos se
passaram de um ponto no script para outro, pois tick() sempre incrementa
de segundo para segundo.

Exemplo de uso.

```
local current_time = tick()

wait(3)

print(tick()-current_time)
```
A saída é 3, pois 3 segundos se passaram.

---
### VecAdd()

Retorna um novo vetor apartir da soma de dois vectores passados  

---