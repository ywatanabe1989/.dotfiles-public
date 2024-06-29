## Gets app-specific passwords
- Gmail
    - https://myaccount.google.com/apppasswords
<!-- - Microsoft
 !--     - https://support.microsoft.com/en-au/account-billing/using-app-passwords-with-apps-that-don-t-support-two-step-verification-5896ed9b-4263-e681-128a-a6f2979a7944 -->

## Encrypts app passwords using openssl
See ['../.bin/encrypt'](../.bin/encrypt) and ['../.bin/decrypt'](../.bin/decrypt)

``` bash
encrypt -h # Usage: /home/ywatanabe/.bin/encrypt [-p PW (def: hoge)] [-t TGT (def: aaa)]
encrypt -p MY_PASSWORD -t MY_FILE # $HOME/.pw/MY_FILE.enc was created

decrypt -h # Usage: /home/ywatanabe/.bin/decrypt [-t TGT (def: aaa]
decrypt -t MY_FILE # MY_PASSWORD
```

## Starts mu
See ['../.bash.d/secrets/030-mu.sh'](../.bash.d/secrets/030-mu.sh)
``` bash
mu-init
```

## ~/.mbsyncrc
See ['../.mbsyncrc'](../.mbsyncrc)

```
# mbsync -V -a

## mu4e.el (emacs config)
See ['../.emacs.d/inits/160-secrets-mu4e.el'](../.emacs.d/inits/160-secrets-mu4e.el)
```

## Reference
- https://f-santos.gitlab.io/2020-04-24-mu4e.html
- https://support.microsoft.com/en-au/office/pop-imap-and-smtp-settings-for-outlook-com-d088b986-291d-42b8-9564-9c414e2aa040
