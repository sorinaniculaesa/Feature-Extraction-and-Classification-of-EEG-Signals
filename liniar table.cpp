#include <stdio.h>
#include <stdint.h>

#define N 16 // Dimensiunea S-Box-ului (4 biți)

uint8_t S_box[16] = { 0xE, 0x4, 0xD, 0x1, 0x2, 0xF, 0xB, 0x8,
                      0x3, 0xA, 0x6, 0xC, 0x5, 0x9, 0x0, 0x7 };

// Funcție pentru calculul parității (numărul de 1 în XOR)
int parity(uint8_t x) {
    int p = 0;
    while (x) {
        p ^= (x & 1);
        x >>= 1;
    }
    return p;
}

// Funcție pentru calculul LAT
void compute_LAT(int lat[N][N]) {
    for (int alpha = 0; alpha < N; alpha++) { // Masca de intrare
        for (int beta = 0; beta < N; beta++) { // Masca de ieșire
            int count = 0;

            for (int x = 0; x < N; x++) { // Parcurgem toate intrările
                int input_masked = parity(alpha & x);
                int output_masked = parity(beta & S_box[x]);

                if (input_masked == output_masked) {
                    count++;
                }
            }

            lat[alpha][beta] = count - (N / 2); // Centrare în jurul valorii 0
        }
    }
}

// Funcție pentru afișarea tabelului LAT
void print_LAT(int lat[N][N]) {
    printf("Linear Approximation Table:\n");
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            printf("%3d ", lat[i][j]);
        }
        printf("\n");
    }
}

int main() {
    int lat[N][N];

    compute_LAT(lat); // Calculăm tabelul LAT

    print_LAT(lat); // Afișăm LAT-ul

    return 0;
}

