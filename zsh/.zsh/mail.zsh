function mailsnow {
    mails=(~/.mail/abdullah/INBOX/new/*(N))
    (( $#mails )) && print  ✉ $#mails
}


