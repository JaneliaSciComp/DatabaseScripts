#!/bin/bash
################################################################################
# Autor     : Guilherme Augusto da Rocha Silva                                 #
# Data      : 20/02/2006                                                       #
# Objetivo  : Monitorar processos e arquivos temporários no PostgreSQL.        #
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
function consulta_bd() {
   sep_itens="," # Separador de itens do resultado da consulta.
   for resultado in $(psql -U postgres template1 -t -c "SELECT d.datname || '${sep_itens}' || d.datid || '${sep_itens}' || d.numbackends || '${sep_itens}' || a.procpid || '${sep_itens}' || a.usename FROM pg_stat_database d LEFT OUTER JOIN pg_stat_activity a ON (d.datid=a.datid) WHERE d.datname NOT LIKE 'template%' ORDER BY d.datname;")
   do
      # Array com dados de processo em excução fornecido pelo SGBD.
      #    [0] = Nome da base.
      #    [1] = OID da base.
      #    [2] = Número de conexões ativas (backends).
      #    [3] = Número do processo (PID)
      #    [4] = Nome do usuário no SGBD.
      unset query
      unset processo_bd
      processo_bd=($(echo "${resultado}" | awk -F"${sep_itens}" '{print $1,$2,$3,$4,$5}'))
      if [ $(echo -e "${#processo_bd[*]}") -gt 0 ]; then
         # Recuperação da consulta SQL em execução.
         query=$(psql -U postgres template1 -t -c "SELECT current_query FROM pg_stat_activity WHERE datid=${processo_bd[1]} AND procpid=${processo_bd[3]}")
         # Array com dados de processo em excução fornecido pelo SO.
         #    [0] = Nome do usuário no SO.
         #    [1] = Número do processo (PID).
         #    [2] = Percentual de CPU usada.
         #    [3] = Percentual de RAM usada.
         #    [4] = Tamanho da memória virtual.
         #    [5] = Tamanho da memória residente.
         #    [6] = Terminal.
         #    [7] = Status do processo.
         #    [8] = Data/hora de início do processamento.
         #    [9] = Tempo de processamento.
         #    [10...] = Linha de comando. Ignorada temporáriamente.
         unset processo_so
         processo_so=($(COLUMNS=180 ps aux | grep -i ${processo_bd[0]} | grep ${processo_bd[3]} | grep -v "grep"))

         # Identificação de arquivos temporários.
         unset tmp_dir
         unset tmp_arq
         tmp_dir=${dir_base}"/"${processo_bd[1]}"/pgsql_tmp"
         tmp_arq=$(find ${tmp_dir} -type f -iname "pgsql_tmp"${processo_bd[3]}"*" 2> /dev/null);
         if [ ! -z "${tmp_arq}" ]; then
            unset tmp_du
            unset tmp_pid
            unset tmp_seq
            unset tmp_tam
            tmp_du=$(du -h ${tmp_arq} 2> /dev/null);
            tmp_pid=$(echo "${tmp_du}" | awk '{print $2}' | sed "s;${tmp_dir}/pgsql_tmp;;" | awk -F\. '{print $1}' 2> /dev/null);
            tmp_seq=$(echo "${tmp_du}" | awk '{print $2}' | sed "s;${tmp_dir}/pgsql_tmp;;" | awk -F\. '{print $2}' 2> /dev/null);
            tmp_tam=$(echo "${tmp_du}" | awk '{print $1}' 2> /dev/null);
         fi
         # Montagem da mensagem para exibição.
         msg=""
         msg=${msg}"\nDATABASE :\t"${processo_bd[0]}" (oid: "${processo_bd[1]}", conexões: "${processo_bd[2]}")"
         msg=${msg}"\nPROCESSO :\tPID: "${processo_so[1]}"\tSTATUS: "${processo_so[7]}"\tINICIO: "${processo_so[8]}"\tTEMPO: "${processo_so[9]}
         msg=${msg}"\nRECURSOS :\tCPU: "${processo_so[2]}"\tMEM: "${processo_so[3]}"\tVSZ: "${processo_so[4]}"\tRSS: "${processo_so[5]}
         msg=${msg}"\nUSUARIOS :\tPG: "${processo_bd[4]}"\tSO: "${processo_so[0]}"\tTTY: "${processo_so[6]}
         if [ ! -z "${tmp_pid}" ] && [ "${tmp_pid}" == "${processo_so[1]}" ]; then
         msg=${msg}"\nPGSQL-TMP:\tTAM: "${tmp_tam}"\tSEQ: "${tmp_seq}
         fi
         msg=${msg}"\nCOMANDOS :\n${query}"
         echo -e "${msg}"
      fi
   done;
}

################################################################################
# Processamento.
################################################################################
if [ "$1" ]; then tempo=$1; else tempo=5; fi # Tempo entre varreduras em diretórios no loop principal.
while true
do
   clear
   exibir_cabecalho
   consulta_bd
   sleep ${tempo}
done
