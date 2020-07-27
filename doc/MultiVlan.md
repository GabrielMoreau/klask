# Multi-VLAN Klask configuration

Pourquoi configurer le multi-VLAN ? Klask a besoin d'établir la correspondance entre l'adresse IP et l'adresse physique de la machine (MAC). Il ne doit pas y avoir de routeur sur le chemin que parcours le paquet IP sinon c'est l'adresse MAC du routeur qui sera mis en correspondance de l'adresse IP de la machine. Celle-ci sera donc positionné sur le plan au même endroit que le routeur !

On explique la configuration pour une machine de type debian. Si votre système est autre, merci de me faire parvenir les subtilités propre à votre distribution.

On fait l'hypothèse que l'on utilise les VLAN 20, 21 et 22. Le VLAN 20 est le VLAN natif de la machine, donc il n'y a rien à configurer par défaut pour lui.

## Configuration du commutateur

Imaginons que votre commutateur soit de marque HP et que vous soyez sur le port 1 de celui-ci. Il faut aller dans la configuration de celui-ci dans le menu VLAN et mettre les valeurs suivantes pour le port 1

```bash
VLAN 20 -> Untagged
VLAN 21 -> Tagged
VLAN 22 -> Tagged
```

## Configuration du réseau sous Linux

Il faut mettre en place la pile 802.1Q dans le noyau. Plutôt qu'un grand discours, un petit script qui va bien

```bash
# Ne pas mettre 20, le VLAN par défaut.
VLAN_ADMIN_NUMBER="21 22"

# charge le module noyau au cas ou
/sbin/lsmod | /bin/grep -q 8021q || /sbin/modprobe 8021q

DEFAULT_INTERFACE=$(/sbin/route | /bin/grep default | /bin/sed -e 's/[[:space:]]\+/ /g' | /usr/bin/cut -f 8 -d ' ')

for vlan in $VLAN_ADMIN_NUMBER
do
   # active la configuration du VLAN
   /bin/egrep -q "\b${vlan}\b" /proc/net/vlan/config || /sbin/vconfig add $DEFAULT_INTERFACE $vlan > /dev/null
   
   # monte l'interface reseau
   if /bin/grep -q  "$DEFAULT_INTERFACE.$vlan inet" /etc/network/interfaces
   then
      /sbin/ifup eth0.$vlan > /dev/null 2>&1
   fi
done
```

En parallèle, on ajoute les interfaces dans son fichier ```/etc/network/interfaces```. La subtilité a lieu pour le VLAN 22 dans cette configuration car il y a deux sous-réseaux dans ce VLAN. On rajoute donc 'à la main' une route vers l'autre sous-réseau afin de ne pas faire transiter les paquets par le routeur.

Les interfaces eth0.21 et eth0.22 ne sont pas en mode 'auto' car pour qu'elles fonctionnent, il faut que la pile 802.1Q soit chargée. C'est donc le script ci-dessus qui les active via la commande ifup.

```bash
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
        address   Mon_Reseau20.Mon_IP20
        netmask   255.255.255.0
        network   Mon_Reseau20.0
        broadcast Mon_Reseau20.255
        gateway   Mon_Reseau20.GW20
        # dns-* options are implemented by the resolvconf package, if installed
        dns-nameservers Mon_SERVER_DNS
        dns-search Mon_Domaine

iface eth0.21 inet static
        address   Mon_Reseau21.Mon_IP21
        netmask   255.255.255.0
        broadcast Mon_Reseau21.255

iface eth0.22 inet static
        address   Mon_Reseau22.Mon_IP22
        netmask   255.255.255.0
        broadcast Mon_Reseau22.255
        up   route add -net Autre_Reseau22.0 netmask 255.255.255.0 dev eth0.22
        down route del -net Autre_Reseau22.0 netmask 255.255.255.0 dev eth0.22
```

## Configuration de Arpwatch

Cela se passe dans le fichier ```/etc/arpwatch.conf```

```bash
eth0    -m klask
eth0.21 -m klask
eth0.22 -m klask
```

Comme on envoie les courriels d'arpwatch à un utilisateur s'appelant 'klask', il faut le configurer dans le fichier ```/etc/aliases``` afin de rediriger ces courriels vers un utilisateur réel ou sur un robot d'archivage...

```bash
klask: Mon_Utilisateur@Mon_Serveur_De_Courriel
```

## Configuration de Klask

Il n'y a rien à faire ;-) On indique juste dans le fichier de configuration de Klask sur quelle interface est attachée un réseau.
