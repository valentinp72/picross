const LARGEUR_CARTE = 35;
const HAUTEUR_CARTE = 35;

let largeurAffichage = 5;
let hauteurAffichage = 5;

const INCREMENT_TAILLE = 5;

const CELL_WHITE = " ";
const CELL_BLACK = "O";
const CELL_CROSS = "X";

const WIDTH_CELL  = 15;
const HEIGHT_CELL = 15;

const NB_CHIFFRES = 12;

const WIDTH  = (WIDTH_CELL * LARGEUR_CARTE) + (WIDTH_CELL * NB_CHIFFRES) + 1;
const HEIGHT = (HEIGHT_CELL * HAUTEUR_CARTE) + (HEIGHT_CELL * NB_CHIFFRES) + 1;

let solution = [];
let carte = [];
let chiffresHaut = [];
let chiffresGauche = [];

function setup(){
	createCanvas(WIDTH, HEIGHT);
	textSize(20);
	textFont("Arial");

	chiffresHaut = new Array(NB_CHIFFRES);
	for(var i = 0 ; i < NB_CHIFFRES ; i++) {
		chiffresHaut[i] = new Array(LARGEUR_CARTE);
		for(var j = 0 ; j < LARGEUR_CARTE ; j++) {
			chiffresHaut[i][j] = 0;
		}
	}

	chiffresGauche = new Array(HAUTEUR_CARTE);
	for(var i = 0 ; i < HAUTEUR_CARTE ; i++) {
		chiffresGauche[i] = new Array(NB_CHIFFRES);
		for(var j = 0 ; j < NB_CHIFFRES ; j++) {
			chiffresGauche[i][j] = 0;
		}
	}

	carte    = new Array(HAUTEUR_CARTE);
	solution = new Array(HAUTEUR_CARTE);
	for(var i = 0 ; i < HAUTEUR_CARTE ; i++) {
		carte[i]    = new Array(LARGEUR_CARTE);
		solution[i] = new Array(LARGEUR_CARTE);
		for(var j = 0 ; j < LARGEUR_CARTE ; j++) {
			carte[i][j]    = CELL_WHITE;
			solution[i][j] = CELL_CROSS;
		}
	}

	// random init
	for(var i = 0 ; i < HAUTEUR_CARTE ; i++) {
		for(var j = 0 ; j < LARGEUR_CARTE ; j++) {
			if(Math.random() > 0.5)
				solution[i][j] = CELL_BLACK;
		}
	}

	nombresInit();
	clearCarte();
}

function nombresInit() {

	// RAZ
	for(var i = 0 ; i < NB_CHIFFRES ; i++) {
		for(var j = 0 ; j < LARGEUR_CARTE ; j++) {
			chiffresHaut[i][j] = 0;
		}
	}

	for(var i = 0 ; i < HAUTEUR_CARTE ; i++) {
		for(var j = 0 ; j < NB_CHIFFRES ; j++) {
			chiffresGauche[i][j] = 0;
		}
	}

	// nombres haut init
	for(var i = 0 ; i < largeurAffichage ; i++) {
		var taille   = 0;
		var indexPos = NB_CHIFFRES - 1;
		for(j = hauteurAffichage - 1 ; j >= 0 && indexPos > 0; j--) {
			if(solution[j][i] == CELL_BLACK) {
				taille++;
			}
			else if(taille != 0){
				chiffresHaut[indexPos][i] = taille;
				taille = 0;
				indexPos--;
			}
		}
		if(taille != 0){
			chiffresHaut[indexPos][i] = taille;
			taille = 0;
		}
	}

	// nombres gauche init
	for(var i = 0 ; i < hauteurAffichage ; i++) {
		var taille   = 0;
		var indexPos = NB_CHIFFRES - 1;
		for(j = largeurAffichage - 1 ; j >= 0 && indexPos > 0; j--) {
			if(solution[i][j] == CELL_BLACK) {
				taille++;
			}
			else if(taille != 0){
				chiffresGauche[i][indexPos] = taille;
				taille = 0;
				indexPos--;
			}
		}
		if(taille != 0){
			chiffresGauche[i][indexPos] = taille;
			taille = 0;
		}
	}


}

function draw(){

	clear(); // obligatoire quand on diminue la taille de la grille

	strokeWeight(1);
	stroke(100);
	textSize(12);

	// chifres haut
	for(var i = 0 ; i < NB_CHIFFRES ; i++) {
		for(var j = 0 ; j < largeurAffichage ; j++) {
			fill(color(240, 240, 240));
			rect((j + NB_CHIFFRES) * WIDTH_CELL, i * HEIGHT_CELL, WIDTH_CELL, HEIGHT_CELL);
			if(chiffresHaut[i][j] != 0) {
				fill(0, 102, 153);
				text(chiffresHaut[i][j], (j + NB_CHIFFRES) * WIDTH_CELL + WIDTH_CELL/4, (i + 1) * HEIGHT_CELL - HEIGHT_CELL/6);
			}
		}
	}

	// chifres gauche
	for(var i = 0 ; i < hauteurAffichage ; i++) {
		for(var j = 0 ; j < NB_CHIFFRES ; j++) {
			fill(color(240, 240, 240));
			rect(j * WIDTH_CELL, (i + NB_CHIFFRES) * HEIGHT_CELL, WIDTH_CELL, HEIGHT_CELL);
			if(chiffresGauche[i][j] != 0) {
				fill(0, 102, 153);
				text(chiffresGauche[i][j], (j) * WIDTH_CELL + WIDTH_CELL/4, (i + 1 + NB_CHIFFRES) * HEIGHT_CELL - HEIGHT_CELL/6);
			}
		}
	}


	// jeu

	stroke(1);

	for(var i = 0 ; i < hauteurAffichage ; i++) {
		for(var j = 0 ; j < largeurAffichage ; j++) {
			if(carte[i][j] == CELL_WHITE) {
				fill(color(255, 255, 255));
			}
			else if (carte[i][j] == CELL_BLACK) {
				fill(color(0, 0, 0));
			}
			else {
				fill(color(200, 200, 200));
			}
			rect((j + NB_CHIFFRES) * WIDTH_CELL, (i + NB_CHIFFRES) * HEIGHT_CELL, WIDTH_CELL, HEIGHT_CELL);
		}
	}


	strokeWeight(4);

	// lignes verticales
	for(var i = 0 ; i <= largeurAffichage ; i += 5) {
		line((i + NB_CHIFFRES) * WIDTH_CELL, NB_CHIFFRES * HEIGHT_CELL, (i+NB_CHIFFRES) * WIDTH_CELL, (hauteurAffichage + NB_CHIFFRES) * HEIGHT_CELL);
	}

	// lignes horizontales
	for(var i = 0 ; i <= hauteurAffichage ; i += 5) {
		line(NB_CHIFFRES * WIDTH_CELL, (i + NB_CHIFFRES) * HEIGHT_CELL, (largeurAffichage + NB_CHIFFRES) * WIDTH_CELL, (i + NB_CHIFFRES) * HEIGHT_CELL);
	}

}



function mouseClicked() {
	//mouseX
	//mouseY

	// console.log("X:" + (Math.trunc(mouseX / WIDTH_CELL) - NB_CHIFFRES));
	// console.log("Y:" + (Math.trunc(mouseY / HEIGHT_CELL) - NB_CHIFFRES));

	let coordX = Math.trunc((mouseX / WIDTH_CELL) - NB_CHIFFRES);
	let coordY = Math.trunc((mouseY / HEIGHT_CELL) - NB_CHIFFRES);

	if(coordX >= 0 && coordX < LARGEUR_CARTE) {
		if(coordY >= 0 && coordY < HAUTEUR_CARTE) {
			if(carte[coordY][coordX] == CELL_WHITE) {
				carte[coordY][coordX] = CELL_BLACK;
			}
			else if(carte[coordY][coordX] == CELL_BLACK) {
				carte[coordY][coordX] = CELL_CROSS;
			}
			else {
				carte[coordY][coordX] = CELL_WHITE;
			}

			if(carte[coordY][coordX] != solution[coordY][coordX]) {
				//window.alert("HEY!");
			}
		}
	}

}

function keyTyped() {

	// appuyer sur E pour exporter (export) la carte
	if(key == 'e' || key == 'E') {
		exportCarte();
	}

	// appuyer sur L pour charger (load) la carte
	if(key == 'l' || key == 'L') {
		loadCarte("d");
	}

	// appuyer sur C pour effacer (clear) la carte
	if(key == 'c' || key == 'C') {
		clearCarte();
	}

	// appuyer sur P pour afficher (print) la carte
	if(key == 'p' || key == 'P') {
		printCarte();
	}

	// appuyer sur P pour afficher (print) la carte
	if(key == 'r' || key == 'R') {
		location.reload();
	}

	// appuyer sur A pour augmenter la taille de la carte
	if(key == 'a' || key == 'A') {

		if(largeurAffichage + INCREMENT_TAILLE <= LARGEUR_CARTE) {
			largeurAffichage += INCREMENT_TAILLE;
		}
		if(hauteurAffichage + INCREMENT_TAILLE <= HAUTEUR_CARTE) {
			hauteurAffichage += INCREMENT_TAILLE;
		}
		nombresInit();

	}

	// appuyer sur D pour diminuer la taille de la carte
	if(key == 'd' || key == 'D') {

		if(largeurAffichage - INCREMENT_TAILLE > 0) {
			largeurAffichage -= INCREMENT_TAILLE;
		}

		if(hauteurAffichage - INCREMENT_TAILLE > 0) {
			hauteurAffichage -= INCREMENT_TAILLE;
		}
		nombresInit();
	}

}

function exportCarte() {
	window.alert("Sauvegardez ceci : \n" + JSON.stringify(carte));
}

function loadCarte(stringCarte) {
	load = window.prompt("Chargement : ","Entrez votre sauvegarde ici");
	carte = JSON.parse(load);
	nombresInit();
//	clearCarte();
}
function clearCarte() {
	for(var i = 0 ; i < HAUTEUR_CARTE ; i++) {
		for(var j = 0 ; j < LARGEUR_CARTE ; j++) {
			carte[i][j] = CELL_WHITE;
		}
	}
}
function printCarte() {
	for(var i = 0 ; i < hauteurAffichage ; i++) {
		for(var j = 0 ; j < largeurAffichage ; j++) {
			carte[i][j] = solution[i][j];
		}
	}
}
