#!/bin/bash
#The script which creating users from text document with spesific params
echo "----------------------Script for creating users-----------------------"
echo -e "\n\n"
echo "Text document which contains users should be placed in directory src"
echo -e "\n"
read -p  "Enter name of the file which contains users with params: " FILE_USERS


USERS_PATH="./src/$FILE_USERS"


if [[ -f $USERS_PATH ]]; then
	IFS=$'\n'


	for LINE in `cat $USERS_PATH`
	do

		username=`echo "$LINE" | cut -d ":" -f1`
		user_shell=`echo "$LINE" | cut -d ":" -f4`
		user_group=`echo "$LINE" | cut -d ":" -f2`
		user_password=`echo "$LINE" | cut -d ":" -f3`
		ssl_password=`openssl passwd -1 $user_password`
		if ! grep -q $username "/etc/passwd"; then
			echo "$username  was not found in system!"
			read -p "Do you want to create a new user $username [yes/no]" ANS_NEW
			case $ANS_NEW in
				[Yy]|[Yy][Ee][Ss])


				if [[ `grep $user_group /etc/group` ]]; then
					echo "$Group user_group already exist in the system"
				    useradd $username -s $user_shell -m -g $user_group -p $ssl_password

				else
					echo  -e " Group $user_group does not exist in the system\nIt will be created!"
					groupadd $user_group
					useradd $username -s $user_shell -m -g $user_group -p $ssl_password

				fi
				echo "User $username was created!\n"
				;;
				[Nn]|[Nn][Oo])
					echo -e "The creation of user $username will skip\n"
					;;

				*)
				echo -e "Please enter [yes/no] only\n"
				;;
			esac


		elif [[ `grep $username "/etc/passwd"` ]]; then
			echo "$username was found in system!"	
			read -p "Do you want to make some changes for $username? (yes/no): " ANSWER_CHANGES
			case $ANSWER_CHANGES in
				[Yy]|[Yy][Ee][Ss])
				    echo -e "You answered yes!\n";;
				   
			

				[Nn]|[Nn][Oo])
					echo -e "You answered no!\n";;
				*)
					echo "You need to enter only YES/NO!!!";;
			esac
		fi	

	done


else
	echo "$FILE_USERS doesn't exist"
	echo "You need to create a new file!"

fi


# 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