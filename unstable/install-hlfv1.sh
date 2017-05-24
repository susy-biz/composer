(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else   
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� �N%Y �]Ys�Jγ~5/����o�Jմ6 ����)�v6!!~��/ql[7��/������|�tN7n�O��/�i� h�<^Q�D^���Q��F�/�c�F~Nwc����V��N��4{��k��P����~�MC{9=��i��>dF\.�&�J�e�5�ߖ��2.�?�8^ɿ�Y���4��%I���P�wo{�{�l�\�Z�9�%���}��S���p���cQ%�p_����˰3]�?�GS�C'�'���c����$M}�u>�?�p'�4��?k�Z�?��4B�����yNٔK�(M�(M�Iظ�E����OS$����Q����O�7�gͽ
?G�?�?E�h����{d���s��#e�n����Ć��D^�ZO�M`���h�� ���@EYF�]6�/L�&����(ŵ`��l�ZЦ
3!���S>�A���U��,r�4A�8�:VblRzw��xn��E���uVz:��)K����ԍp7��A*�D������8�uY����G�D�ˁ/ԵoߠSgEUx�k����������������w�U�������]����u�G���G	{j�	��������Eݐ%�/���e�i�<p�!�e���,%>���-3�x�\���2@���d>��4M 3.T�,�x�LMk�y�DC)Ё�sJ[ä���nD&�!N;�q;E`�F�{��3{�Μ��+�9x��n�\�sv?>�;� =.TM(���Q��F�N�$"�J��Q�x$rQ&���}Yn	bG�s&
o��N< :�94��:q���[{(���\C0��)�p#ica���1���8?�.�B~A�'�xh���Tn�pJ�۟i��B�ӛ�B"N�U1"�6o��b�IdJ؍�i�v�k���2uN�em
h�	���\2T�p;ByWZj�����՝)�̵����y
 ���r��sM<�<���i��b���B���J�ύ%(��}��t9^eu�Ș��6|#;��a��l�E�$m.o4F�t�4W���%�(‗5����e�Ob`���1f��:���a�����w�\��$mIm45Q��u�!�%�H�X4�9����l���܆g�����r�K�?��o����?�W�_
>H��ʟ� ��?���1��*�/��8+�߉��_j�a�l���j�����y·�܎��a���D�Џ�B�~Ĩo'T�CR���8(�X\L$�(+�앙{_�H�?�������J�gF�D���d�{'ZL��%p�k�9jXC"ԗ������ۻz��-�{��c��"�s1����V���( ͽ���K���2�,\�թ� �����&́�m���9�zKӔ3#gh�ˋ*�?�|^ o秛�8^���X{x�gB��Z���C]��;����6%�|�H�9��NA�A�9lQ��Q�f��LH��5>�8�hQ�y��k�_8
r���M��X����sS��gr]K���m3�>�P�0Y����O�K�ߵ������$���R�!��Y���=�?B#h��e���������\����s/�-(����K������+��T�?U�ϯ�?�St���{e���	p�d��CД�4�2��:F������8�^���w�����(��*����\��÷{�`?�hR��Ñ�z���:�%��"" �����2�^��Y��l�V0#&㆜4M��2��[��a=���j�K�9��n��vdA{0���m-��v���
��%H��,e{V�?��/��g��T��������?de��@��W��U���߻��g��T�_
>H���?$����J������ߛ9	�G(L���.@^����`���W�%��wkp��L̇0�н4��>�
��*@�tb�I�7���txs�;��H��H�\u:w��f�z3�7l�k���AS�(^��BA�:ܠ�ɪc��,�=Ѻ�i[<2.g�cFґ����9��A�6h�p�4�	Cr��}El	`�8�v�vSt���MV&�����-�3�q�|�0�ٓI�28	LE5�xǰW�|h֣�ZLB6ޮ;-�mvZgiϔ��uG=��f�TS�%������d�R$/k7t !s���IV=h��x��_�����CU�_>D����S�)���*����?�x��w�wv9��Z�)�D��������1%*�/�W�_������C�J=��(A���2p	�{�M:x������Юoh�a8�zn��(°J",�8, �Ϣ4K��]e��~(C����!4�W�_� �Oe®ȯV+U���؜����=�i�m����?��)���W��}'��N�VRjhH�(�Nb{��W#�D�Q�[��nno��P�' �!H�g�A+z�d�~8�����fU�߻�X�����?�����j���A���y
�;�����rp��o__f.�?NЕ������A��˗����q���_>R�/m�X�8�!���R�;��`8�|�']����O��F�"�g1"`1Ǳm�el��P��%X�=,�
e�]�� g	&�f�G����P��/_�����O�������.���}�Z"&
/&�nPo��4L�˹z�t�H�����?�M��]��簺��\��@w��G��p��|�y�H>h��[>#~*�m��C��Z�D\TG��A�ك��W�?��G��K�A���T������CI��G!x����O��՗fU(e���%ȧ���U��P
^��j�<���ϝ���k�KX0�}C~v��x���?K�ߟ����q��O��r1�K�Zo�H_������~�9���9���A��=zе�î�{&N>��)�b,��W�Km;��~�ILW���	�<�-b�Zt3����������P�YOԉ5�����j�s�ފ���{�A3Q�t�r֓��ex�L>2�{Ġ��Ām���N��-���|�����E�ք~ހNYe�6�xN�/ݩ�۝�ؐ�����^��.uF$��m�,O7|���0�v�X���M�i����o�)��足��Y�9ˌ������mo9�� ����N�ʹ��\��ފ��>�[Z��>\d��BiH�?/�#��K������x��������������9����*�-Q��_�����$P�:���m�G�~�Ǹ0l�^�-��If�����l�G���?�e~��Q~(�b�n#�[�������<�Z�� 컮�O���� �B$�vr��))�ci�J�hl�F�˶���[��SS�m�ߚ���&4�T6c��ij]�r�
��H��'}5i�v��@���qv��K����>@ k��#'P#�ڬ��]z�M��J̳F��K]��O�\;|�՞ق%w��Z�o�~�;�F�&����-T�}z�x������#��K�A\��#4U�������'��T�J�g�����A������?+���Q��W�������F���S`.��1�~��\.�˽�������,�W�_��������E=_��~��\���G�4�a(�R�C�,�2��`���h��.��>J8d��T��>B�.�8�W���V(C���?:������Rp����Lɖ�þeN�6;}�!Bs�m�me�E��#mѢ&/��1ќ��J;�����(���)�G�  �mow���c�o]�5�Oaz���z8#P�249�P�7�+u�Ŧ=4����^������(�3�z->�?������(Z��W)��iVX������ (�������P�����R�M#;���&��O���N:u�\�뎡n(�
�F��+{�L��g��v����_��7�ծj�t����M����`��?��ձ~z�`����=�E#$���ϿNe�č����MjWn�����Ż�]%��Պ`��k�>��yh�:�7������'�ծ��i���ӿI�W��;�6^l"��]×�������v��k{��ӛ��µo�nn}�ۙ��]�+���Es���.�7Quй��}CT� �b���>�y���ڗ��h4�·�l_k*ɝ���@�w�:��4̮o�ʵ�(��˝���{��{�@���ւ�?�A�%wۋ70:��bl��X|W{���e�-o�� ��O[/�������^����N�~z7��5x���ߟ�ʾ��?��c��?m�\�{�����q:�.�o�~��q���8��8K]8��'�0Y?P�GR��j�X��"GC������sվ����}��?��Y<�4�?6��Wlñ�E��������w�F���Y��{�@�Uő�m�n��ŦR���ʪ�m����0<��5��S8�,�'u�=T��'����Ƹn���r{;=��N]���6���[�q>���'�I��d��z�N��;�R	!	X��Ђ�GH�� ������Zv�V~ �N�I&�Lf:�-ž��~ϧ��9�_?�L�-4���-ނ٦�9�db�˅[r(!a�q(�R���e�||5<��@W$��s�D�V:KFIhm��1�ɓ�����e4�"�v��h=0-�@,���M=
D�iM:&��,�� �1a��;]]Yt�UEQ\���ZM��p	24A���a�Ԏ�Ȁ�a� ���]f\�a�Xxd��ݮf@݄�h<6UIp�>:M�G��;����x:�����|)�eXh9��ߪ�u��t_!�-��W�샙�f^�9-��9�XFBlQ��ܼ���F�j_4�W���Bi5^�2V5Q;5������^�M��h����t��n�t���)v8]�ȁSN���%8%������tva��;�G�_gw�A���MM�G���:�U��(�!<���=j]S���m���T��_�:��l&m��Dw=aw�����冭숂��]5_���PFV&:�t�3�^?��ǣ5��fa
���E[I\}8-��B�i�}l�6��"�����L)��m�~�cr]�	EnZ����������Vp�gI���-qAhIf�r��ӑ{G�z!]OW�jK�&@���(���{E����RE���'ie��~,IA�HDL���,!�V�C��2c�V�mI�2��6Zz��-d�sm?|CX*�N(��j�I���UY��^��ꅭ������]h�[��,�1�t�i��M������3�|>y�66<��Ze��ǋ���,~�������?��~�O��օ�K[?�ӧ�w��[%n<��ս��x�!�t��}?�������"����@��a>!�	>`B����E�{G�����CW~���O=X��ۅ�\��S�r���� �<π�Bw>� �u����p��n�7pG^xx�������!_��|�����\<���M���M��殴D`��sܼ����	9��e!���L�|k�2'�Zפ�kM�4�O�0�z緅��"ׇɞ ��í�ލ���7��z��h��Ʃa��z�`)���gǜP�r��T�A�E�°X���e�by\ĉ\����9��-����G�l�lC�p%JSE����aT`�������q�e�lx�#\b�U�0O΄Wɂcv{k��H.��\k7S�<tJ�T}�f�8`�d�R��W3����Ҿ�G�i�R�^E�U��1��3zFC�~�a��V�#�!_��0a&�Ä݄	�|�D�ݏ����ѹM=!�ڛz�S�k~~K�)����FȺW�(%��x���c^2��$ӡ\Z��R����L���Hb����sa�P�q��k�=��\�η��bJ��Q�CV���,��fP���A*ҍ�x��S��^��+XBV��E�>�����ë���j2F3�X�'��lDI��8-+�z�����z��
7��T�D�%%��Ho3\��m4_}e�����ـuAY����BDKt��:���(�M�4��V�(��N<Z���>�u��H1J�3�̈́KIF��N ��ڨ���锅��h�&�FK�:`X�pE2�Q2K�rDxAv���u	��x60�)�/&�N�WC� PO/W�h���$f)�h\/�q����Τc� Vhs��TO{��<�EJ���$V)�p���W�����c0r�&q��y �y�ᩱ7-��F��_"�hPˊb�,�"�GI-^V�
�ԸV��ɖp�{�XBi�)����S���n(�Q���z����?�e<�\U�%e9"� �VY��.�q���!+Ut	e�<;(-����?�����ݖ����h�B�R�_��˱|Z�1l�����^�;NY܎���l�϶�϶s�4~�w��FW��]ȵ�;�d��^غc�
���Wi;�Lϐ�ʾ}.�6re>����EeE�v��v��滂l���^�����{چ-��B��9(�*a�<���#AԺ��L.�<�&1��ht���U�@�抺��WĎ�3�#MD��Kࢡ*�-��X��5�"����~�ocW�y�e7�mw�U��֛0��}������"�4jV͑�"�B�{��1���m���¼��)����up��4������1+V��)��A�� �����@��U �]V$}������D��?���y��6�ۇ�9/�K��/ϝ8tOL���Қ�Z�(��P������KJ�𠭎����h.:�Ok��xX���6]p�rd����κ��V��4�5gс<8�,DJLE�>���ޘ�UZ�2��}|L#b���\(+��VpLu�X<���0��h�/��R��Q��*E���t�MB%�,��5��Y��؃�a�If�d1A��2���99}3�Y����p�D4�j(��A��{��\||@�=�NjL�\�@s�D�#�@V,�	Ez@-������*�G}X��|�i����x82�x/$�AB
wd}�f0���P�vK��B���j4��8.5�� ��c����c�q���z��G��A��s��e��:&�)f>ӆ)0۳{y
>8��^䲝���yX�=,�����x�x�{[<,'��Ɖ�m:���#|����j�ԅ4o~~D,)����9,Py����6��A�YL�5(2��E�5gY���0�ryg�����"�v��#tX�c���݌!�O�ZG���zBɪ֧�V�`�����qt4�h��Q0&!E��`��X8m0�0B���E��}��b���q߁��p����'U�w1\Ԇ����E���rU�zcR�)�~%S#Ӣ.U�1��R3�ǃ(��������!��-x ��ӢQmV
�~��&=�f���]�yc�1�8�ތ�Tޏw1ⷑS�=�S��b���F!��l;7��V�.�w�8oȍ����=��ӭh��_�qߜ��4�I�j�h�{�>p�����������&�mA���\����ܨWY���U���"r��vso���ˏ�����z?����/~��{��^��s~r��ou���k�ws��c�D�s.�D�'�?��G���?o��;��~������w����#�_~2����y�^��'�_��s�"��I�$�b��[w�x��C�+z�+��D���\�]�Cw�������[������/�������#�a�K�+����gn��Ej�/j�C�t��M��	8�N�+���+��v��ӡv:�N�gs|�����|����q
R�&4� �J���E.h�o��U��Y�s ��[������>F�����ב��	/ ��q����)������p��5���#y��� 3���Ks�l�yZΜ'��̙q�8��93�q8�q�̜a����܎�97�;w��ڦ��W�<z�d�������s�p�p����W5?Y�  