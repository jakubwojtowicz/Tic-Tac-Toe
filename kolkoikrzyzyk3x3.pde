char[][] tablica = new char[3][3];
char ksztalt_gracza = 'X';
int score;
int i_1;
int j_1;
PFont f;
char kogo_ruch = 'X';
char kogo_ruch2 = 'X';
int i_ruch;
int j_ruch; 
int licznik_ruchow = 0;
  
//ta funkcja wykonuje się raz
void setup(){
//utowrzenie okna
size(600, 800);
//kolor tla
background(65,105,225);
//grubosc linii
strokeWeight(2);
//kolor linii
stroke(255, 255, 255);
for(int i = 0; i<4; i++){
  //rysowanie linii
  line(i*200,0,i*200,600);
}
for(int i = 0; i<4; i++){
  line(0,i*200,600,i*200);
  
}
noFill();
//utworzenie czcionki
f = createFont("Arial",40,true);
textFont(f,50);

for(int i = 0; i<3; i++){
   for(int j = 0; j<3; j++){
    tablica[i][j] = 'P'; //P - puste, O - kropka, X - krzyzyk
    }
}
}

//ta funkcja dziala w petli jak loop w arduino
void draw(){
      if(kogo_ruch == 'O'&&sprawdz_wynik(kogo_ruch2, i_ruch, j_ruch)=='C'){
        bestmove();
      }
      
      char wynik = sprawdz_wynik(kogo_ruch2, i_ruch, j_ruch);
        if (wynik == 'O'){
          fill(255);
          text("Zwycięstwo O!", 190, 700); 
          noLoop();
        }
        if (wynik == 'X'){
          fill(255);
          text("Zwycięstwo X!", 190, 700);
          noLoop();
        }
        if (wynik == 'T'){
          fill(255);
          text("Remis!", 190, 700);
          noLoop();
        }
}

void wykonaj_ruch(int i, int j){
  tablica[i][j] = 'O';
  strokeWeight(2);
  stroke(255, 255, 255);
  //narysowanie kola
  ellipse(j*200+100,i*200+100, 190, 190);
}


void bestmove(){
  int bestScore = Integer.MIN_VALUE;
    for(int k = 0; k<3; k++){
     for(int l = 0; l<3; l++){
       if(tablica[k][l]=='P'){
         tablica[k][l] = 'O';
         i_ruch = k;
         j_ruch = l;
         kogo_ruch2 = 'O';
         licznik_ruchow++;
         score = minimax(10,false,Integer.MIN_VALUE,Integer.MAX_VALUE);
         licznik_ruchow--;
         tablica[k][l] = 'P';
        if(score > bestScore){
          bestScore = score;
          i_1 = k;
          j_1 = l; 
        }
       }
     }
     }
     i_ruch = i_1;
     j_ruch = j_1;
     wykonaj_ruch(i_1,j_1);
     kogo_ruch2 = 'O';
     licznik_ruchow++;
     kogo_ruch = 'X';
      return;
}

int minimax(int depth, boolean maximizingplayer,int alpha, int beta){
 
  char wynik = sprawdz_wynik(kogo_ruch2, i_ruch, j_ruch);
  if(wynik !='C' || depth == 0){
    if(wynik=='T') return 0;
    if(wynik=='O') return 10;
    if(wynik=='X') return -10;
  }

  if (maximizingplayer){
    int bestScore = Integer.MIN_VALUE;
    for(int i = 0; i<3; i++){
      for(int j = 0; j<3; j++){
        if(tablica[i][j]=='P'){
          tablica[i][j] = 'O';
          i_ruch = i;
          j_ruch = j;
          licznik_ruchow++;
          kogo_ruch2 = 'O';
          bestScore = max(bestScore, minimax(depth-1,false,alpha,beta));
          licznik_ruchow--;
          kogo_ruch2 = 'X';
          tablica[i][j] = 'P';
          alpha = max(alpha,bestScore);
          if(beta<=alpha)break;
        }
      }
    }
    return bestScore;
  }
  else{
    int bestScore = Integer.MAX_VALUE;
     for(int i = 0; i<3; i++){
        for(int j = 0; j<3; j++){
          if(tablica[i][j] == 'P'){
            tablica[i][j] = 'X';
            i_ruch = i;
            j_ruch = j;
            kogo_ruch2 = 'X';
            licznik_ruchow++;
            bestScore = min(bestScore,minimax(depth-1,true,alpha,beta));
            licznik_ruchow--;
            kogo_ruch2 = 'O';
            tablica[i][j] = 'P';
            beta = min(beta,bestScore);
            if(beta<= alpha) break;
          }
        }
     }
    return bestScore;
  }
}

 
char sprawdz_wynik(char kogo_ruch_ostatni, int i_ruch_ostatni, int j_ruch_ostatni){
  //przekatna
  if(i_ruch_ostatni == j_ruch_ostatni){
    for(int i = 0; i<=2 ; i++){
      if(tablica[i][i] != kogo_ruch_ostatni)break;
      if (i == 2)return kogo_ruch_ostatni;        
    }
  }
  //antyprzekatna
  if(i_ruch_ostatni == 2-j_ruch_ostatni){
    for(int i = 0; i<=2 ; i++){
      if(tablica[i][2-i] != kogo_ruch_ostatni)break;
      if (i == 2)return kogo_ruch_ostatni;
    }
  }
  
  //poziom
  for(int i = 0; i<=2 ; i++){
      if(tablica[i_ruch_ostatni][i] != kogo_ruch_ostatni)break;
      if (i == 2)return kogo_ruch_ostatni;
  }
    
  //pion
  for(int i = 0; i<=3 ; i++){
      if(tablica[i][j_ruch_ostatni] != kogo_ruch_ostatni)break;
      if (i == 2)return kogo_ruch_ostatni;     
      }
      
  if(licznik_ruchow == 9) return 'T';
  else return 'C';  
}

//funkcja która wywoluje się po wcisnieciu myszki 
void mousePressed() {
  j_ruch = mouseX/200;
  i_ruch = mouseY/200;
  strokeWeight(2);
  stroke(255, 255, 255);
  if(kogo_ruch == 'X' && tablica[i_ruch][j_ruch] != 'O'){
      tablica[i_ruch][j_ruch] = 'X';
      int X = j_ruch*200 +100;
      int Y = i_ruch*200 +100;
      line(X-100,Y+100,X+100,Y-100);
      line(X-100, Y-100, X+100, Y+100);
      kogo_ruch = 'O';
      kogo_ruch2 = 'X';
      licznik_ruchow++;
   } 
}
