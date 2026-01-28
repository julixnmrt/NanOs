void kernel_main(void) {
    // Pointeur vers la mémoire vidéo VGA
    volatile unsigned short *video = (volatile unsigned short *)0xB8000;
    
    // Effacer l'écran (noir)
    for (int i = 0; i < 80 * 25; i++) {
        video[i] = 0x0F20; // espace blanc sur noir
    }
    
    // Message à afficher
    const char *msg = "*** KERNEL BOOTED SUCCESSFULLY! ***";
    
    // Afficher au centre (ligne 12, colonne 22)
    int pos = 12 * 80 + 22;
    
    for (int i = 0; msg[i] != '\0'; i++) {
        // Attribut: 0x0A = vert clair sur noir
        video[pos + i] = (0x0A << 8) | msg[i];
    }
    
    // Boucle infinie
    while (1) {
        __asm__ volatile("hlt");
    }
}