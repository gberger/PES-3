# PES-3

# Configurando ambiente
1. instale docker-engine. https://docs.docker.com/engine/installation/
2. instale docker-compose. https://docs.docker.com/compose/install/
3. entre no diretório do projeto
4. rode no terminal: docker-compose build
5. rode no terminal: docker-compose up
6. teste acessando: http://localhost:3005/ ou http://localhost:3005/hellolua/



# Fontes úteis sobre o que estamos usando
* NGINX: http://nginx.org/en/docs/beginners_guide.html
* Módulo de lua para NGINX: https://www.nginx.com/resources/wiki/modules/lua/
* Módulo de Upload para NGINX: https://www.nginx.com/resources/wiki/modules/upload/
* Driver de mongo para lua: https://github.com/mongodb-labs/mongorover
* Sessões para lua com nginx (Talvez a gente nem precise): https://github.com/bungle/lua-resty-session
