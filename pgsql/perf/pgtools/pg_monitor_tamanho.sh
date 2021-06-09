#!/bin/bash
################################################################################
# Autor     : Guilherme Augusto da Rocha Silva                                 #
# Data      : 20/02/2006                                                       #
# Objetivo  : Verificar o tamanho de uma ou mais bases de dados do PostgreSQL. #
# Observação: Para uso no Linux.                                               #
################################################################################

################################################################################
# Variáveis.
################################################################################
script=$(basename ${0})              # Nome deste programa.
versao="0.1"                         # Versão deste programa.
release="20060706a"                  # Release deste programa.
versao_pg="8.1"                      # Versão corrente do PostgreSQL.
usuario=$(whoami);                   # Usuário corrente.

# Definição do diretório da instância ($PGDATA).
if [ ! -z ${PGDATA} ]; then
   dir_data=${PGDATA}                # Associação com a variável de ambiente $PGDATA.
elif [ ! -z ${POSTGRES_DATA} ]; then
   dir_data=${POSTGRES_DATA}         # Associação com a variável alternativa de ambiente $POSTGRES_DATA.
else
   dir_data="/var/lib/postgres/data" # Associação com o path default.
fi
dir_base=${dir_data}"/base"          # Diretório das bases de dados.
dir_xlog=${dir_data}"/pg_xlog"       # Diretório dos logs de transação.
dir_clog=${dir_data}"/pg_clog"       # Diretório dos logs de controle de transação.

# Controle para exibição de informações de debug (0 = não debugar; 1 = debugar).
if [ ! -z "$1" ]; then
   debugar=1
else
   debugar=0
fi

################################################################################
# Funções.
################################################################################
# Função para abortar exibindo mensagem.
function abortar() {
   if [ ! -z "$1" ]; then linha=$1; else linha=${LINENO}; fi
   if [ ! -z "$2" ]; then sinal=$2; else sinal=1; fi
   if [ ! -z "$3" ]; then texto=$3; else texto="Abortando a execução devido a um erro desconhecido!"; fi
   echo -e "\nERRO:\t"${texto}
   if [ ${debugar} -gt 0 ]; then echo -e "\n\t(DEBUG: linha="${linha}"; tempo="${SECONDS}")"; fi # gars - informação de debug.
   echo ""
   exit ${sinal}
}
# Função para exibir cabecalho do programa.
function exibir_cabecalho() {
   msg="################################################################################"
   msg=${msg}"\n# ${script} (v${versao}, r${release})"
   msg=${msg}"\n# Servidor : $HOSTNAME"
   msg=${msg}"\n# Data/hora: $(date +%d\/%m\/%Y\ %H\:%M\:%S\ %Z)"
   msg=${msg}"\n################################################################################"
   echo -e ${msg}
}
# Função para verificar a instância do PostgreSQL (PGDATA).
function verifica_pgdata() {
   formato_pg=$(cat ${dir_data}"/PG_VERSION" 2> /dev/null)
   if [ ! -d ${dir_data} ] || [ -z "${formato_pg}" ]; then
      abortar ${LINENO} 1 "Não existe um diretório de trabalho válido para PostgreSQL."
   else
      if [ "${formato_pg}" != "${versao_pg}" ]; then
         abortar ${LINENO} 1 "Versão estrutural da instância difere da versão atual do PostgreSQL."
      fi
   fi
   if [ ! -d ${dir_data}/base ]; then
      abortar ${LINENO} 1 "Não existe uma instância do PostgreSQL em ${dir_data}."
   fi
}
# Função para verificar se o serviço do PostgreSQL está ativo.
function verifica_servico_postgresql() {
   postmaster_pid=${dir_data}"/postmaster.pid"
   if [ -r "${postmaster_pid}" ]; then
      processo_pg=$(COLUMNS=180 ps -p $(cat ${postmaster_pid} | head -1) | grep -v "PID" | awk '{print $NF}') # copiado do script ('/etc/init.d/postgresql').
      if [ "${processo_pg}" != "postmaster" ]; then
         abortar ${LINENO} "1" "O serviço PostgreSQL está parado!"
      fi
   else
      abortar ${LINENO} 1 "O serviço PostgreSQL está parado!"
   fi
}
# Função para gerar arrays de oids e de nomes (ambos sincronizados entre si pelas respectivas posições de índices).
# Retorna 0 e gera os arrays "id" e "bd".
function gerar_listas() {
   i=0 # Índice do array "bases".
   j=0 # Índice dos arrays "id" e "bd".
   sql="SELECT oid || ' ' || datname FROM pg_database WHERE datallowconn IS TRUE AND datname != 'template0' ORDER BY datname"
   # Criação de array monovalorado, composto por oid e nome da base, em linhas subsequentes (oid na 1a, nome na 2a, oid na 3a, nome na 4a...).
   bases=($(psql -U postgres template1 -t -c "${sql}"))
   while [ ${i} -lt ${#bases[*]} ]
   do
      modulo=$((${i} % 2)) # Definição se o índice atual é par ou ímpar.
      if [ ${modulo} -eq 0 ]; then
         ids[${j}]=${bases[${i}]} # Montagem de array "id".
         j=$((${j} + 1)) # Incremento do índice de "id" e "bd".
      elif [ ${modulo} -eq 1 ]; then
         bds[$((${j} - 1))]=${bases[${i}]} # Montagem de array "bd".
      fi
      i=$((${i} + 1)) # Incremento do índice de "bases".
   done
   return 0
}

################################################################################
# Verificações iniciais.
################################################################################
# Exibição de título.
exibir_cabecalho

if [ "${usuario}" != "root" ] && [ "${usuario}" != "postgres" ]; then
   abortar ${LINENO} 1 "Este programa deve ser executado apenas\n\tpor super-usuários do sistema operacional!"
fi
# Verifica se o diretório 'data' é uma instância de bancos de dados.
verifica_pgdata
# Verifica se o serviço do PostgreSQL está ativo.
verifica_servico_postgresql

################################################################################
# Processamento.
################################################################################
# Geração dos arrays de oids ("ids") e de nomes ("bds") das bases de dados.
gerar_listas

# Exibição dos tamanhos individuais das bases de dados.
echo -e "\n== Tamanho da(s) base(s) =="
k=0 # Contador dos arrays
while [ ${k} -lt ${#ids[*]} ]
do
   alvo=${dir_base}"/"${ids[$k]}"/"
   if [ -d ${alvo} ]; then
      tam=$(du -hsL ${alvo} | awk '{print $1}')
      echo -e "   ["${ids[$k]}"] "${bds[$k]}"\t--->\t"${tam}
   fi
   k=$((${k} + 1)) # atualização da posição atual
done
# Exibição de tamanhos dos demais diretórios e total da instância.
echo -e "
== Totalizações ==
   Bases de dados ativas              : ${k}
   Tamanho das bases de dados         : $(du -hsL ${dir_base} | awk '{print $1}')
   Arquivos de logs de transação (WAL): $(ls -1 ${dir_xlog} | wc -l)
   Tamanho dos logs de transação (WAL): $(du -hsL ${dir_xlog} | awk '{print $1}')
   Tamanho total da instância (PGDATA): $(du -hsL ${dir_data} | awk '{print $1}')

== Uso do disco =="
df -hT
echo ""
