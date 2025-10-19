#!/bin/bash

while true; do
  opcao=$(dialog --menu "Opções:" 15 40 4 \
  1 "CRIAR DIRETÓRIO" \
  2 "CRIAR ARQUIVO" \
  3 "MUDAR PERMISSÕES DE ARQUIVO/DIRETÓRIO" \
  4 "MOVER ARQUIVO" \
  5 "PREENCHER ARQUIVO" \
  6 "EXIBIR DATA/HORA DO SISTEMA" \
  7 "ALTERAR DATA/HORA DO SISTEMA" \
  8 "SAIR" \
  3>&1 1>&2 2>&3)

  clear

  case $opcao in

   1)

     nome=$(dialog --inputbox "Nome do diretório:" 8 40 3>&1 1>&2 2>&3)
     clear
     if [ -n "$nome" ]; then
         mkdir "$nome" 
         dialog --msgbox "Diretório foi criado!" 6 40
     else
         dialog --msgbox "Ação cancelada!" 6 40
     fi 
     ;;

   2)
      clear
      nome=$(dialog --inputbox "Nome do arquivo:" 8 40 3>&1 1>&2 2>&3)
      nome="${nome}.txt"
      if [ -n "$nome" ]; then
         touch "$nome"
         dialog --msgbox "Arquivo foi criado!" 6 40
      else
         dialog --msgbox "Ação cancelada!" 6 40
      fi
      ;;
   

    3)
       clear
       opcao3=$(dialog --menu "Você quer mudar permissão de um arquivo ou diretório?" 15 40 4 \
       1 "ARQUIVO" \
       2 "DIRETÓRIO" \
       3>&1 1>&2 2>&3)

       clear
       case $opcao3 in
       1)
         clear
         nome=$(dialog --inputbox "Nome do Arquivo:" 8 40 3>&1 1>&2 2>&3)
         resposta=$?
         [[ "$nome" != *.txt ]] && nome="${nome}.txt"
         clear

         if [[ $resposta -ne 0 || -z "$nome" ]]; then
           dialog --msgbox "Ação cancelada!" 10 40
            continue
         fi

         opcao2=$(dialog --menu "Permissões:" 15 40 4 \
         1 "SOMENTE LEITURA" \
         2 "EXECUÇÃO" \
         3 "PERSONALIZÁVEL" \
         3>&1 1>&2 2>&3)

         clear
         case $opcao2 in
          1)
            clear
            if [[ -f "$nome" ]]; then
              chmod 444 "$nome"
              dialog --msgbox "Permissão somente leitura garantida (arquivo)!" 10 40
            else
              dialog --msgbox "Arquivo não encontrado!" 10 40
            fi
            ;;
          2)
            clear
            if [[ -f "$nome" ]]; then
              chmod +x "$nome"
              dialog --msgbox "Permissão de execução aplicada!" 10 40
            else
              dialog --msgbox "Arquivo não encontrado!" 10 40
            fi
            ;;
          3)
            clear
            permissao=$(dialog --inputbox "Digite o valor de permissão (ex: 764):" 10 40 3>&1 1>&2 2>&3)
            [ $? -ne 0 ] && dialog --msgbox "Ação cancelada!" 10 40 && continue

            if [[ -f "$nome" ]]; then
             chmod "$permissao" "$nome"
             dialog --msgbox "Permissão $permissao aplicada com sucesso!" 10 40
            else
             dialog --msgbox "Arquivo não encontrado!" 10 40
            fi
            ;;
         esac
            ;;

       2)
         clear
         nome=$(dialog --inputbox "Nome do Diretório:" 8 40 3>&1 1>&2 2>&3)
         resposta=$?
         clear

         if [[ $resposta -ne 0 || -z "$nome" ]]; then
            dialog --msgbox "Ação cancelada!" 10 40
             continue
         fi

         opcao2=$(dialog --menu "Permissões:" 15 40 4 \
         1 "SOMENTE LEITURA" \
         2 "EXECUÇÃO" \
         3 "PERSONALIZÁVEL" \
         3>&1 1>&2 2>&3)

        clear
        case $opcao2 in
        1)
          clear
          if [[ -d "$nome" ]]; then
            chmod 555 "$nome"
            dialog --msgbox "Permissão somente leitura garantida (diretório)!" 10 40
          else
            dialog --msgbox "Diretório não encontrado!" 10 40
          fi
          ;;
        2)
          clear
          if [[ -d "$nome" ]]; then
             chmod +x "$nome"
             dialog --msgbox "Permissão de execução aplicada!" 10 40
          else
             dialog --msgbox "Diretório não encontrado!" 10 40
          fi
          ;;
        3)
          clear
          permissao=$(dialog --inputbox "Digite o valor de permissão (ex: 755):" 10 40 3>&1 1>&2 2>&3)
          [ $? -ne 0 ] && dialog --msgbox "Ação cancelada!" 10 40 && continue

          if [[ -d "$nome" ]]; then
            chmod "$permissao" "$nome"
            dialog --msgbox "Permissão $permissao aplicada com sucesso!" 10 40
          else
            dialog --msgbox "Diretório não encontrado!" 10 40
          fi
          ;;
        esac
         ;;
    esac
       ;;
    4)
      clear
      nome=$(dialog --inputbox "Nome do Arquivo que deseja mover:" 8 40 3>&1 1>&2 2>&3)
      [[ "$nome" != *.txt ]] && nome="${nome}.txt"
      nome1=$(dialog --inputbox "Nome do diretório de destino:" 8 40 3>&1 1>&2 2>&3) 
      if [[ -n "$nome" && -n "$nome1" ]]; then
          mv "$nome" "$nome1"
          dialog --msgbox "Arquivo movido com sucesso!" 10 40
      else
          dialog --msgbox "Ação cancelada!" 10 40
      fi ;;

   5)
      clear
      nome=$(dialog --inputbox "Nome do Arquivo que deseja preencher:" 8 40 3>&1 1>&2 2>&3)
      resposta=$?
      clear
      if [[ $resposta -ne 0 || -z "$nome" ]]; then
        dialog --msgbox "Ação cancelada!" 10 40
        continue
      fi
    
      [[ "$nome" != *.txt ]] && nome="${nome}.txt"         

      opcao1=$(dialog --menu "Preencher com:" 15 40 4 \
      1 "TEXTO" \
      2 "COMANDOS" \
      3>&1 1>&2 2>&3)
       
      clear

      case $opcao1 in
        1)
           clear
           texto=$(dialog --inputbox "Digite o texto:" 8 40 3>&1 1>&2 2>&3)
           if [ -n "$texto" ]; then
             echo "$texto" >> "$nome"
             dialog --msgbox "Arquivo preenchido!" 10 40
           else
             dialog --msgbox "Ação cancelada!" 10 40
           fi
           ;;
       
       2)
          clear
          comando=$(dialog --inputbox "Digite comando:" 10 40 3>&1 1>&2 2>&3)  
          if [[ -n "$comando" && -n "$nome" ]];then
            if [[ "$comando" == "top" ]]; then
             top -b -n 1 > "$nome"  
            else  
               $comando > "$nome"
            fi   
             dialog --msgbox "Preenchido com comando!" 10 40
          else
             dialog --msgbox "Ação cancelada!" 10 40
          fi
    ;;
      esac
    
    ;;


   6)
      clear
      dialog --msgbox "$(date)" 10 40

    ;;

   7)
      clear
      data=$(dialog --inputbox "Digite a nova data (formato: AAAA-MM-DD):" 10 40 3>&1 1>&2 2>&3)
      [ $? -ne 0 ] && dialog --msgbox "Ação cancelada!" 10 40 && continue 

      hora=$(dialog --inputbox "Digite a nova hora (formato: HH:MM:SS):" 10 40 3>&1 1>&2 2>&3)
      [ $? -ne 0 ] && dialog --msgbox "Ação cancelada!" 10 40 && continue
      
      sudo timedatectl set-ntp false      
      sudo date -s "$data $hora" > /dev/null 2>&1


      if [ $? -eq 0 ]; then
        atual=$(date)
        dialog --msgbox "Data e hora atualizadas com sucesso!" 10 40
      else
        dialog --msgbox "Erro ao atualizar data/hora." 10 50
      fi
    ;;

   8)

     exit ;;

 esac
done
