#!/bin/bash
################################################################################
# Autor     : Guilherme Augusto da Rocha Silva                                 #
# Data      : 20/02/2006                                                       #
# Objetivo  : Verificar o tamanho de uma ou mais bases de dados do PostgreSQL. #
# Observa��o: Para uso no Linux.                                               #
################################################################################

################################################################################
# Vari�veis.
################################################################################
script=$(basename ${0})              # Nome deste programa.
versao="0.1"                         # Vers�o deste programa.
release="20060706a"                  # Release deste programa.
versao_pg="8.1"                      # Vers�o corrente do PostgreSQL.
usuario=$(whoami);                   # Usu�rio corrente.

# Defini��o do diret�rio da inst�ncia ($PGDATA).
if [ ! -z ${PGDATA} ]; then
   dir_data=${PGDATA}                # Associa��o com a vari�vel de ambiente $PGDATA.
elif [ ! -z ${POSTGRES_DATA} ]; then
   dir_data=${POSTGRES_DATA}         # Associa��o com a vari�vel alternativa de ambiente $POSTGRES_DATA.
else
   dir_data="/var/lib/postgres/data" # Associa��o com o path default.
fi
dir_base=${dir_data}"/base"          # Diret�rio das bases de dados.
dir_xlog=${dir_data}"/pg_xlog"       # Diret�rio dos logs de transa��o.
dir_clog=${dir_data}"/pg_clog"       # Diret�rio dos logs de controle de transa��o.

# Controle para exibi��o de informa��es de debug (0 = n�o debugar; 1 = debugar).
if [ ! -z "$1" ]; then
   debugar=1
else
   debugar=0
fi

################################################################################
# Fun��es.
################################################################################
# Fun��o para abortar exibindo mensagem.
function abortar() {
   if [ ! -z "$1" ]; then linha=$1; else linha=${LINENO}; fi
   if [ ! -z "$2" ]; then sinal=$2; else sinal=1; fi
   if [ ! -z "$3" ]; then texto=$3; else texto="Abortando a execu��o devido a um erro desconhecido!"; fi
   echo -e "\nERRO:\t"${texto}
   if [ ${debugar} -gt 0 ]; then echo -e "\n\t(DEBUG: linha="${linha}"; tempo="${SECONDS}")"; fi # gars - informa��o de debug.
   echo ""
   exit ${sinal}
}
# Fun��o para exibir cabecalho do programa.
function exibir_cabecalho() {
   msg="################################################################################"
   msg=${msg}"\n# ${script} (v${versao}, r${release})"
   msg=${msg}"\n# Servidor : $HOSTNAME"
   msg=${msg}"\n# Data/hora: $(date +%d\/%m\/%Y\ %H\:%M\:%S\ %Z)"
   msg=${msg}"\n################################################################################"
   echo -e ${msg}
}
# Fun��o para verificar a inst�ncia do PostgreSQL (PGDATA).
function verifica_pgdata() {
   formato_pg=$(cat ${dir_data}"/PG_VERSION" 2> /dev/null)
   if [ ! -d ${dir_data} ] || [ -z "${formato_pg}" ]; then
      abortar ${LINENO} 1 "N�o existe um diret�rio de trabalho v�lido para PostgreSQL."
   else
      if [ "${formato_pg}" != "${versao_pg}" ]; then
         abortar ${LINENO} 1 "Vers�o estrutural da inst�ncia difere da vers�o atual do PostgreSQL."
      fi
   fi
   if [ ! -d ${dir_data}/base ]; then
      abortar ${LINENO} 1 "N�o existe uma inst�ncia do PostgreSQL em ${dir_data}."
   fi
}
# Fun��o para verificar se o servi�o do PostgreSQL est� ativo.
function verifica_servico_postgresql() {
   postmaster_pid=${dir_data}"/postmaster.pid"
   if [ -r "${postmaster_pid}" ]; then
      processo_pg=$(COLUMNS=180 ps -p $(cat ${postmaster_pid} | head -1) | grep -v "PID" | awk '{print $NF}') # copiado do script ('/etc/init.d/postgresql').
      if [ "${processo_pg}" != "postmaster" ]; then
         abortar ${LINENO} "1" "O servi�o PostgreSQL est� parado!"
      fi
   else
      abortar ${LINENO} 1 "O servi�o PostgreSQL est� parado!"
   fi
}
# Fun��o para gerar arrays de oids e de nomes (ambos sincronizados entre si pelas respectivas posi��es de �ndices).
# Retorna 0 e gera os arrays "id" e "bd".
function gerar_listas() {
   i=0 # �ndice do array "bases".
   j=0 # �ndice dos arrays "id" e "bd".
   sql="SELECT oid || ' ' || datname FROM pg_database WHERE datallowconn IS TRUE AND datname != 'template0' ORDER BY datname"
   # Cria��o de array monovalorado, composto por oid e nome da base, em linhas subsequentes (oid na 1a, nome na 2a, oid na 3a, nome na 4a...).
   bases=($(psql -U postgres template1 -t -c "${sql}"))
   while [ ${i} -lt ${#bases[*]} ]
   do
      modulo=$((${i} % 2)) # Defini��o se o �ndice atual � par ou �mpar.
      if [ ${modulo} -eq 0 ]; then
         ids[${j}]=${bases[${i}]} # Montagem de array "id".
         j=$((${j} + 1)) # Incremento do �ndice de "id" e "bd".
      elif [ ${modulo} -eq 1 ]; then
         bds[$((${j} - 1))]=${bases[${i}]} # Montagem de array "bd".
      fi
      i=$((${i} + 1)) # Incremento do �ndice de "bases".
   done
   return 0
}

################################################################################
# Verifica��es iniciais.
################################################################################
# Exibi��o de t�tulo.
exibir_cabecalho

if [ "${usuario}" != "root" ] && [ "${usuario}" != "postgres" ]; then
   abortar ${LINENO} 1 "Este programa deve ser executado apenas\n\tpor super-usu�rios do sistema operacional!"
fi
# Verifica se o diret�rio 'data' � uma inst�ncia de bancos de dados.
verifica_pgdata
# Verifica se o servi�o do PostgreSQL est� ativo.
verifica_servico_postgresql

################################################################################
# Processamento.
################################################################################
# Gera��o dos arrays de oids ("ids") e de nomes ("bds") das bases de dados.
gerar_listas

# Exibi��o dos tamanhos individuais das bases de dados.
echo -e "\n== Tamanho da(s) base(s) =="
k=0 # Contador dos arrays
while [ ${k} -lt ${#ids[*]} ]
do
   alvo=${dir_base}"/"${ids[$k]}"/"
   if [ -d ${alvo} ]; then
      tam=$(du -hsL ${alvo} | awk '{print $1}')
      echo -e "   ["${ids[$k]}"] "${bds[$k]}"\t--->\t"${tam}
   fi
   k=$((${k} + 1)) # atualiza��o da posi��o atual
done
# Exibi��o de tamanhos dos demais diret�rios e total da inst�ncia.
echo -e "
== Totaliza��es ==
   Bases de dados ativas              : ${k}
   Tamanho das bases de dados         : $(du -hsL ${dir_base} | awk '{print $1}')
   Arquivos de logs de transa��o (WAL): $(ls -1 ${dir_xlog} | wc -l)
   Tamanho dos logs de transa��o (WAL): $(du -hsL ${dir_xlog} | awk '{print $1}')
   Tamanho total da inst�ncia (PGDATA): $(du -hsL ${dir_data} | awk '{print $1}')

== Uso do disco =="
df -hT
echo ""
