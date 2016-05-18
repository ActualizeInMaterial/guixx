;; This is an operating system configuration template
;; for a "desktop" setup with GNOME and Xfce.

(use-modules (gnu) (gnu system nss) (gnu services xorg)
	     ;;(gnu services networking)
	     )
(use-service-modules desktop)
(use-package-modules certs)

(operating-system
  (host-name "guixqemu")
  (timezone "Europe/Bucharest")
  (locale "en_US.UTF-8")

  ;; Assuming /dev/sdX is the target hard disk, and "my-root"
  ;; is the label of the target root file system.
  (bootloader (grub-configuration (device "/dev/disk/by-id/ata-QEMU_HARDDISK_QM00001")))
  (file-systems (cons (file-system
                        (device "my-root")
                        (title 'label)
                        (mount-point "/")
                        (type "ext4"))
                      %base-file-systems))

  (users (cons (user-account
                (name "a")
                (comment "")
(password "a")
                (group "users")
                (supplementary-groups '("wheel" "netdev"
                                        "audio" "video" "kvm"))
                (home-directory "/home/a"))
               %base-user-accounts))

  ;; This is where we specify system-wide packages.
  (packages
    (append (map specification->package
                 '("tcpdump" "htop" "emacs" "gnupg" "wget" "curl" "font-dejavu"))
            (cons* nss-certs         ;for HTTPS access
                   %base-packages)))

  ;; Add GNOME and/or Xfce---we can choose at the log-in
  ;; screen with F1.  Use the "desktop" services, which
  ;; include the X11 log-in service, networking with Wicd,
  ;; and more.
  (services (cons*
;;	     (dhcp-client-service) ;doesn't work
;;    (console-keymap-service  "dvorak")
	     ;;(gnome-desktop-service)
(static-networking-service "enp0s25" "192.168.1.191"
#:name-servers '("8.8.8.8" "8.8.4.4")
#:gateway "192.168.1.1")
                   (xfce-desktop-service)
                   %desktop-services
;;the following runs window maker instead of slim/xfce! so fail! (unless it was a one time fluke! which I seem to remember happening once! it better not be!!)
;;		   (modify-services %desktop-services
;;		     (slim-service-type config =>
;;					(slim-configuration (inherit config)
;;							    (auto-login? #t)
;;							    (default-user "z"))))
                   ))

  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss))
