#!/bin/bash

################# INFO GERAIS ##############
# @author "Vinícius Alcântara"
# @Maintainer "Vinícius Alcântara"
# @Contact "vinicius.redes2011@gmail.com"

############################################

######### VARIÁVEIS #########
CONTADOR=$(docker container ls -qa | wc -l)
BK_DIR_CONTAINERS="/root/bkContainers"
SRV_DEST="<IP>"
USER_SRV_DEST=root
DIR_SRV_DEST="/root/bkContainers"

#############################################################
######### COMMIT DAS IMAGENS DOS CONTAINER ATUAIS ###########
if [ ! -e $BK_DIR_CONTAINERS ]; then
        mkdir -p $BK_DIR_CONTAINERS
        cd $BK_DIR_CONTAINERS
else
        cd $BK_DIR_CONTAINERS
fi

###################################
######### BACKUP IMAGES ###########
for CONTAINER_NAME in $(docker ps -a --format "table {{.Names}}" | tail -n $CONTADOR);
do
        echo $CONTAINER_NAME.tar >> lista_containers_name.txt
        docker commit $CONTAINER_NAME > $CONTAINER_NAME
for CONTAINER_IMAGE in $(docker image ls -q | head -n $CONTADOR > lista_images.txt && tac lista_images.txt);
do
        docker save $CONTAINER_IMAGE > $CONTAINER_NAME.tar
done
done

##################################
########## UPLOAD BACKUPS ########

rsync -avh -e "ssh -p 145" *.tar $USER_SRV_DEST@$SRV_DEST:/$DIR_SRV_DEST

##################################
~                                         
