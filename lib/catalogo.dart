// GERADO POR ferramentas/catalogo.py — NÃO EDITAR À MÃO.
//
// ====================================================================
// AS ESPÉCIES QUE SÓ O CATÁLOGO DE NOMES ALCANÇA
// 
// A ficha do aplicativo nasce de duas normas: a IN MMA 53/2005, que dá
// tamanho mínimo, e o Anexo I da Portaria GM/MMA 1.667/2026, que dá a
// Lista de ameaçadas. Espécie fora das duas não tinha página — e quem
// procurava por ela não achava nada.
// 
// Foi o caso da carapeba. A pessoa digita "carapeba", a espécie não tem
// tamanho mínimo nem está na Lista, e o aplicativo ficava mudo. O
// silêncio é lido como permissão, que é o erro que mais importa evitar.
// 
// Aqui entram as espécies que a Portaria MPA nº 532/2025 nomeia E que
// alguma norma carregada pelo aplicativo cita. O critério é esse, e não
// opinião sobre o que ocorre em Santa Catarina: se nenhuma norma do
// aplicativo nomeia o bicho, ele não ganha página.
// 
// A 532 tem 571 espécies e aqui há 90. As demais são de rotulagem —
// importados, cultivo, esturjões, espécies amazônicas — e nenhuma norma
// de ordenamento do aplicativo fala delas. Continuam achá-veis pela
// busca, que responde com o nome científico e com onde o termo aparece.
// 
// A página que sai daqui NÃO AFIRMA REGRA NENHUMA. Ela diz o nome
// científico, os nomes comuns oficiais, e diz em voz alta as duas
// ausências: sem tamanho mínimo na IN 53, fora da Lista.
// ====================================================================

/// Sinônimos deixados de fora de propósito, para não abrir duas
/// páginas para o mesmo bicho:
///   Pogonias cromis — sinônimo antigo de Pogonias courbina, que já tem ficha. A Portaria SAQ nº 009/2025 do Estado de Santa Catarina registra que as duas foram reconhecidas como espécies distintas e que Pogonias cromis não ocorre no Brasil.

const catalogo = <String>[
  'Acanthocybium solandri', // Cavala
  'Acanthurus bahianus', // Caraúna
  'Alectis ciliaris', // Peixe-Galo
  'Archosargus probatocephalus', // Sargo
  'Auxis thazard', // Bonito
  'Bagre bagre', // Bagre
  'Bagre marinus', // Bagre
  'Brachyplatystoma rousseauxii', // Dourada
  'Brachyplatystoma vaillantii', // Piramutaba
  'Breviraja spinosa', // Arraia
  'Caranx hippos', // Xaréu
  'Caranx latus', // Xaréu
  'Centropomus spp.', // Robalo
  'Cephalopholis fulva', // Piraúna
  'Cetengraulis edentulus', // Biqueirão
  'Chaetodipterus faber', // Paru
  'Cheilopogon cyanopterus', // Peixe-Voador
  'Coryphaena hippurus', // Dourado
  'Cynoscion acoupa', // Pescada
  'Cynoscion guatucupa', // Pescada
  'Cynoscion leiarchus', // Pescada
  'Cynoscion microlepidotus', // Pescada
  'Cynoscion virescens', // Pescada
  'Diapterus auratus', // Carapeba
  'Diapterus rhombeus', // Carapeba
  'Elagatis bipinnulata', // Olhete
  'Engraulis anchoita', // Biqueirão-Argentino
  'Eugerres brasilianus', // Carapeba-Listrada
  'Euthynnus alletteratus', // Bonito
  'Genidens spp.', // Bagre
  'Genyatremus luteus', // Coró
  'Genypterus brasiliensis', // Congro
  'Haemulon aurolineatum', // Xira-Branca
  'Haemulon melanurum', // Sapuruna-de-Listra
  'Haemulon plumierii', // Biquara
  'Harengula clupeola', // Sardinha-Cascuda
  'Helicolenus dactylopterus', // Sarrão
  'Helicolenus lahillei', // Sarrão
  'Hirundichthys affinis', // Peixe-Voador
  'Hoplias malabaricus', // Traíra
  'Hypostomus spp.', // Cascudo
  'Istiophorus albicans', // Agulhão-Vela
  'Katsuwonus pelamis', // Bonito-Listrado
  'Larimus breviceps', // Oveva
  'Lepidocybium flavobrunneum', // Peixe Prego
  'Lobotes surinamensis', // Prejereba
  'Lutjanus analis', // Vermelho
  'Lutjanus jocu', // Vermelho
  'Lutjanus synagris', // Vermelho
  'Lycengraulis grossidens', // Manjuba
  'Mola mola', // Peixe-Lua
  'Ocyurus chrysurus', // Vermelho
  'Pagrus pagrus', // Pargo-Rosa
  'Paralichthys spp.', // Linguado
  'Paralonchurus brasiliensis', // Maria-Luiza
  'Percophis brasiliensis', // Tira-Vira
  'Pinirampus pirinampu', // Piranambú
  'Priacanthus arenatus', // Olho-de-Cão
  'Prionace glauca', // Cação
  'Pristis perotteti', // Peixe-Serra
  'Pseudopercis numida', // Namorado
  'Pseudupeneus maculatus', // Saramonete
  'Rachycentron canadum', // Bejupirá
  'Rajella purpuriventralis', // Arraia
  'Rhomboplites aurorubens', // Vermelho
  'Ruvettus pretiosus', // Peixe-Prego
  'Salminus brasiliensis', // Dourado
  'Sarda sarda', // Bonito
  'Sardinella brasiliensis', // Sardinha
  'Scomber japonicus', // Cavalinha
  'Scomberomorus brasiliensis', // Cavala
  'Scomberomorus cavalla', // Cavala
  'Scomberomorus maculatus', // Cavala
  'Selene vomer', // Peixe-Galo
  'Squalus acanthias', // Cação
  'Squalus blainville', // Cação
  'Squalus cubensis', // Cação
  'Tetrapturus pfluegeri', // Agulhão-Verde
  'Thunnus alalunga', // Atum
  'Thunnus albacares', // Atum
  'Thunnus atlanticus', // Atum
  'Thunnus obesus', // Atum
  'Trachinotus goodei', // Pampo
  'Trachinotus marginatus', // Pampo
  'Trachinotus spp.', // Pampo
  'Xiphias gladius', // Espadarte
  'Zenopsis conchifer', // Peixe-Galo-Branco
  'Zungaro zungaro', // Jaú PEIXES HÍBRIDOS DE INTERESSE COMERCIAL NOME CIENTÍFICO NOME COMUM Colossoma macropomum x
];

/// Quantas espécies entram só pelo catálogo de nomes.
int get quantasSoNoCatalogo => catalogo.length;
