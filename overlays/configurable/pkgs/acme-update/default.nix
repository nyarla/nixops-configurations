{ stdenv, acme-sh, writeScript,
  HOME, DESTDIR, domains }:
stdenv.mkDerivation rec {
  name    = "acme-update";
  version = "2019-11-26";
  src     = "${writeScript "acme-update.sh" ''
    #!${stdenv.shell} 

    set -e -u -o pipefail

    . /etc/credentials/route53.sh

    export HOME=${HOME}

    issue() {
      local domain=$1

      if test ! -d $HOME/.acme.sh ; then
        ${acme-sh}/bin/acme.sh --issue --dns dns_aws -d $domain -d "*.$domain" 
      else
        ${acme-sh}/bin/acme.sh --renew --force --dns dns_aws -d $domain -d "*.$domain" 
      fi

      test -d ${DESTDIR}/$domain || mkdir -p ${DESTDIR}/$domain 

      ${acme-sh}/bin/acme.sh --install-cert -d $domain \
        --key-file ${DESTDIR}/$domain/key.pem \
        --fullchain-file ${DESTDIR}/$domain/fullchain.pem
    }

    ${stdenv.lib.concatMapStrings (domain: ''
      issue ${domain} 
    '') domains}
  ''}";

  phases = [ "installPhase" ];
  
  installPhase = ''
    mkdir -p $out/bin
    cp ${src} $out/bin/acme-update
    chmod +x $out/bin/acme-update
  '';
}
