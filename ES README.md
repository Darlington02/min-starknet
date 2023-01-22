# MIN-STARKNET

Min-StarkNet es un proyecto paralelo influenciado por [Lil-Web3](https://github.com/m1guelpf/lil-web3) de Miguel Piedrafita, destinado a crear implementaciones mínimas e intencionalmente limitadas de diferentes protocolos, estándares y conceptos para ayudar a un principiante de Cairo a aprender y familiarizarse con las sintaxis básicas de Cairo, avanzando rápidamente de principiante a  intermedio😉.

## Empezando
Este proyecto utiliza Protostar como marco de desarrollo. Para comenzar con Protostar, siga las guías contenidas en los [documentos oficiales](https://docs.swmansion.com/protostar/docs/tutorials/installation).

Tenga en cuenta que Protostar actualmente tiene soporte solo para Linux y MacOS, por lo que si está ejecutando un sistema operativo Windows, intente consultar WSL2.

Una vez que haya instalado Protostar, siga adelante para clonar el repositorio ejecutando el siguiente comando en una terminal:

* Original Darlington02

```bash
git clone git@github.com:Darlington02/min-starknet.git
```

* Nadai con Guía

```bash
gh repo clone Nadai2010/Nadai-Min-Starknet
```

**PD: asegúrese de seguir el repositorio, en el orden especificado a continuación para obtener la máxima eficiencia, y siempre lea los comentarios del código para comprender de manera efectiva los códigos subyacentes, Y podría ser útil tener en cuenta también que goerli2 fue la red más utilizada durante el desarrollo**

Finalmente, este repositorio está dirigido a aquellos con conocimientos básicos de cómo funcionan Cairo y StarkNet. Si no comprende la sintaxis básica de El Cairo, tómese un tiempo para leer primero mi serie Journey through Cairo en [medium](https://medium.com/@darlingtonnnam).

---
## MIN-ENS
Min-ens es una implementación simple de un servicio de espacio de nombres en El Cairo. Contiene una sola función externa `store_name` y una sola función de vista `get_name`. Una variable de almacenamiento `names` que es una asignación de **dirección** a **nombre**, también se usa para almacenar los nombres asignados a cada dirección, y un evento **nombre_almacenado** que se emite cada vez que un nombre ¡está almacenado!

También hay disponible un archivo de prueba básico [aquí](https://github.com/Nadai2010/Nadai-Min-Starknet/blob/master/tests/test_ens.cairo) para ayudarlo a aprender los conceptos básicos de la escritura de pruebas en Cairo con Protostar.

* [NADAI GUIA ENS](https://github.com/Nadai2010/Nadai-Min-Starknet/blob/master/src/min_ens/README.md)

---

## MIN-ERC20
Una de las cosas básicas que aprendemos a hacer al comenzar con el desarrollo de contratos inteligentes es aprender a construir e implementar el popular contrato de token ERC2O. En este repositorio, implementamos el estándar ERC20 usando [la biblioteca de Openzeppelin](https://github.com/OpenZeppelin/cairo-contracts/blob/main/src/openzeppelin/token/erc20/library.cairo).

El objetivo de este proyecto es construir e implementar un contrato de token ERC20 simple.

Para mejorar en la redacción de pruebas, puede intentar comprender y replicar la prueba de contrato ERC20 cairo [aquí](https://github.com/Darlington02/min-starknet/blob/master/tests/test_erc20.cairo).

* [NADAI GUIA ERC20](https://github.com/Nadai2010/Nadai-Min-Starknet/blob/master/src/min_erc20/README.md)

---

## MIN-ERC721
Min-erc721 implementa el estándar de token ERC721 (tokens no fungibles) en El Cairo utilizando [la biblioteca de Openzeppelin](https://github.com/OpenZeppelin/cairo-contracts/blob/main/src/openzeppelin/token/erc721/library.cairo).

El objetivo es construir e implementar un contrato ERC721 simple en Starknet.

También hay un archivo de prueba disponible [aquí](https://github.com/Darlington02/min-starknet/blob/master/tests/test_erc721.cairo)

* [NADAI GUIA ERC721](https://github.com/Nadai2010/Nadai-Min-Starknet/blob/master/src/min_erc721/README.md)

---

## MIN-NFT-MARKETPLACE
Min-nft-marketplace es una implementación mínima de un NFT Marketplace para comprar y vender tokens NFT.

Implementa dos funciones externas, `list_token(token_contract_address, token_id, price)` para enumerar tokens en el mercado y `buy_token(listing_id)` para comprar tokens en el mercado.

Los eventos `listing_created` y `listing_sold` también se emiten cada vez que se enumera o vende un token.

**Nota: Recuerde llamar a setApprovalForAll(marketplace_contract_address, true) en el contrato para el NFT que está enumerando antes de llamar a la función `list_token`**

Próximamente archivo de prueba..

* [NADAI GUIA NFT MARKET](https://github.com/Nadai2010/Nadai-Min-Starknet/blob/master/src/min_nft_marketplace/README.md)

---

## MIN-AMM
Min-amm es una implementación mínima de un creador de mercado automatizado en El Cairo. Los códigos fuente se obtuvieron y se modificaron mínimamente de los [Cairo docs](https://www.cairo-lang.org/docs/hello_starknet/amm.html), por lo que puede consultarlos en caso de que se confunda.

También se creó un archivo de prueba [aquí](https://github.com/Nadai2010/Nadai-Min-Starknet/blob/master/tests/test_amm.cairo).

* [NADAI GUIA AMM](https://github.com/Nadai2010/Nadai-Min-Starknet/blob/master/src/min_amm/README.md)

## MIN-ICO
Min-ico es una implementación mínima de una preventa o ICO en El Cairo. Una oferta inicial de monedas **ICO** es el equivalente a una IPO, una forma popular de recaudar fondos para productos y servicios generalmente relacionados con criptomonedas.

El proceso de pensamiento para esta aplicación es que un usuario interesado en participar en la ICO debe registrarse primero con `0.001 ETH` llamando a la función `register` , luego, una vez que expire la duración de la ICO especificada usando `ICO_DURATION`, ahora puede llamar a la función externa `claim` para reclamar su parte de tokens ICO.

PD: Todos los usuarios que participan en la ICO pagan la misma cantidad por el registro y reclaman la misma cantidad de tokens.

**Nota: Recuerde llamar a aprobar(<dirección del contrato>, reg_amount) en el contrato ETH de StarkNet antes de llamar a la función `registrar`**

* [NADAI GUIA ICO](https://github.com/Nadai2010/Nadai-Min-Starknet/blob/master/src/min_ico/README.md)

---

## MIN-STAKING
Min-stake es una implementación mínima de un contrato de staking en El Cairo.

El staking es un proceso popular de bloquear una cierta cantidad de sus tenencias criptográficas para obtener recompensas o ganar intereses.

El proceso de pensamiento para esta aplicación requiere que un usuario primero deposite una cierta cantidad del token ERC20 para apostar llamando a la función `stake (stake_amount, duration_in_secs)`, y finalmente reclame los tokens + el interés acumulado una vez que la duración haya terminado por llamando a la función `claim_rewards(stake_id)`.

**Nota: Recuerde llamar a aprobar(stake_contract_address, stake_amount) en el contrato StarkNet ETH antes de llamar a la función `stake`**

* [NADAI GUIA STAKE](https://github.com/Nadai2010/Nadai-Min-Starknet/blob/master/src/min_staking/README.md)

---

## MIN-ERC20-PUENTE DE MENSAJERÍA
La capacidad de crear puentes de mensajería personalizados en StarkNet para transferencias de datos y activos es una de las características principales que hace que StarkNet se destaque de otros paquetes acumulativos existentes.

En este proyecto, vamos a crear un puente de mensajería ERC20 personalizado simple que puede ayudar a un usuario a transferir un token ERC20 entre StarkNet y Ethereum.

El proceso de pensamiento para esta aplicación es que tenemos un token ERC20 implementado en StarkNet, que pretendemos conectar con Ethereum, para permitir que los usuarios envíen sus tokens entre capas. Primero tenemos que implementar un clon de nuestro token ERC20 en Ethereum, con un suministro inicial cero (esto se hace para garantizar que el suministro total en las diferentes capas, cuando se suma, permanezca constante). Luego implementamos nuestro token bridge en ambas capas, configurando el token ERC20 que queremos unir en particular.

Cada vez que ocurre un puente desde L2 -> L1, los tokens puenteados se bloquean en el contrato puente L2, y la misma cantidad de tokens puenteados se acuñan en L1 para el usuario, y cada vez que ocurre un puente desde L1 -> L2, el los tokens puenteados se queman y la misma cantidad de tokens puenteados se libera o transfiere del contrato puente L2 al usuario, por lo que siempre se mantiene constante el suministro total.

* [NADAI GUIA ERC20 BRIDGE](https://github.com/Nadai2010/Nadai-Min-Starknet/blob/master/src/min_messaging_bridge/README.md)

---

## MIN-UPGRADABILITY
Con Regenesis a la mano, es necesario comprender cómo funcionan los contratos actualizables para poder migrar con éxito los contratos existentes a Cairo v1.0. En esta sección, aprenderemos cómo crear contratos actualizables mediante la codificación de un token ERC20 actualizable.

En términos simples, un contrato actualizable es aquel que le permite cambiar el código/lógica subyacente de su contrato inteligente, sin alterar necesariamente el punto de entrada (dirección del contrato) de su dApp. Esto se hace separando sus contratos en un Proxy y una implementación. El Proxy sirve como punto de entrada y también contiene el almacenamiento del contrato, mientras que la Implementación contiene el código/lógica de su dApp. Para una inmersión más profunda, consulte este artículo de David Baretto [aquí](https://medium.com/starknet-edu/creating-upgradable-smart-contracts-on-starknet-12b7d9bd60c7).

Gracias al equipo de Openzeppelin, ya tenemos una buena plantilla a seguir. Primero tendríamos que copiar el [contrato de proxy](https://github.com/OpenZeppelin/cairo-contracts/blob/main/src/openzeppelin/upgrades/presets/Proxy.cairo) en nuestro repositorio. Este contrato de proxy contiene algunas funciones importantes que debemos comprender:

* El `constructor` que toma 4 parámetros: deployment_hash que es el hash de clase de nuestro contrato de `implementation_hash`, `selector` que es el nombre del selector de nuestra función de inicializador (1295919550572838631247819983596733806859788957403169325509326258146877103642), `calldata_len` que es la longitud de nuestro calldata del contrato de (construcción y argumento) y `calldata` que son los argumentos del constructor del contrato de implementación. El constructor establece el hash de implementación e inicializa el contrato de implementación.

* La función `__default__` que es responsable de redirigir cualquier llamada de función cuyo selector no se pueda encontrar en el contrato del proxy a la implementación.

* La función `__l1_default__` que es responsable de redirigir cualquier función realizada a un @l1_handler cuyo selector no se encuentra en el contrato del proxy a la implementación.

Finalmente, creamos nuestros contratos de implementación agregando funciones como `upgrade` para actualizar el hash de implementación, `setAdmin` para configurar el administrador de proxy, `getImplementationHash` para obtener el hash de clase de contrato de implementación y `getAdmin` para obtener el administrador de proxy actual.

Tenga en cuenta que el contrato de implementación nunca debe:

1. Ser desplegado como un contrato regular. En su lugar, se debe declarar el contrato de implementación (lo que crea una clase declarada que contiene su hash y abi).
2. Establezca su estado inicial con un constructor tradicional (decorado con @constructor). En su lugar, utilice un método de inicialización que invoque al constructor Proxy.

* [NADAI GUIA PROXY V2](https://github.com/Nadai2010/Nadai-NaiProxyV2-Starknet-ERC20)

---

# PLAYGROUND OFICIAL
¿Busca una versión ya implementada de estos contratos? échales un vistazo en StarkScan (Goerli2). 

**PD: si alguna vez se encuentra con un error de asignación, probablemente necesite llamar a la función de aprobación en el contrato ETH de antemano.**

# MIN-ENS
* `ENS` - 0x0340be76bc3bb090a3a339a8ccf6381e7d6620e80e047ddd814268c286dc1e66
# MIN-ERC20
* `ERC20` - 0x064b2aee30d3693237d0e4f1792b0bde2d80f799d2f95ee7cc2bb339b8fce23e
# MIN-ERC721
* `ERC721` - 0x02f5222bdb8e68b59736e1490c5ec36ab32f609e4e7058a4042841a51a6cec94
# MIN-NFT-MARKETPLACE
* `ERC721` - 0x02f5222bdb8e68b59736e1490c5ec36ab32f609e4e7058a4042841a51a6cec94
* `NFTMarket` - 0x05b3f40d5cdac77a4e922d8765a5a6ae96e64dc2a4796187d9a25166d0da2235
# MIN-AMM
* `AMM` - 0x0219cc693096e2d7df6d6145758fe1b63218725054c61e1fe98cf862cb4c2eb9
# MIN-ICO
* `ERC20` - 0x064b2aee30d3693237d0e4f1792b0bde2d80f799d2f95ee7cc2bb339b8fce23e
* `ICO` - 0x028afec7907fa30e16aa62e89658d2a416e00f7917a57502d5dc0e43755df103
# MIN-STAKING
* `ERC20` - 0x064b2aee30d3693237d0e4f1792b0bde2d80f799d2f95ee7cc2bb339b8fce23e
* `STAKING` - 0x06aaa18df6c7a39373d0e153354eda4e1471fab4616837a9ae3295b890abd03a
# MIN-MESSAGING-BRIDGE
* `ERC20` - 0x064b2aee30d3693237d0e4f1792b0bde2d80f799d2f95ee7cc2bb339b8fce23e
* `L2 BRIDGE ADDRESS` - 0x01c22dddbdbb040268b0a2bb79d62602a57726b2532ee015980f033eb10d8472
* `L1 BRIDGE ADDRESS` - 0xD1A3D5b3Aa75f0884001b2F92d4c7E6050B2eF97
# MIN-UPGRADABILITY
* `Proxy class hash` - 0x601407cf04ab1fbab155f913db64891dc749f4343bc9e535bd012234a46dc61
* `Implementation_v0 class hash` - 0x707e746b94ec595a094ff53dfacb0b6ed8117ba7941844766dd34ab7872107a
* `Implementation_v1 class hash` - 0x1b439f0e941915a2a45bed6d5affed2966010bb5e9b682bc4137178af2a9667
* `Deployed contract` - 0x00701816faf15bf9a97132dbc84d594bf4dd12cea878a8e46254a504ee2187e8

**DENTRO DE CADA GUÍA NADAI PODRA ENCONTRAR LOS DEPLOY Y CONTRATOS**

---

# DIRECTRICES DE CONTRIBUCIÓN

Para garantizar que este repositorio se mantenga lo más simple y minimalista posible para no confundir a los principiantes, no se aceptarán contribuciones en forma de agregar nuevos protocolos, pero si cree que vale la pena agregarlo a la lista, envíeme un DM en Twitter [Darlington Nnam](https://twitter.com/0xdarlington). Mientras tanto, podría contribuir en forma de modificaciones a los proyectos existentes enumerados. Un buen lugar para comenzar es revisar los problemas abiertos. Asegúrese de prestar atención a lo siguiente en el curso de la contribución:

1. Mantenga la implementación lo más simple y minimalista posible.
2. Comente los códigos en detalles para permitir que otros entiendan lo que hacen sus códigos. Natspec es la opción preferida.
3. Mantenga sus códigos simples y limpios.
4. Al abrir PR, proporcione una descripción detallada de lo que está tratando de corregir o agregar. Construyamos un excelente REPO de aprendizaje para los frenéticos que buscan comenzar con Cairo.😉

**Si este repositorio fue útil, ¡dale una ESTRELLA!**
