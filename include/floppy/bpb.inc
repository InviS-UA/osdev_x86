Oem:                db 'abcdefgh'
BytesPerSector:     dw 512
SectorsPerCluster:  db 1
ReservedSectors:    dw 1
FATCount:           db 2
RootDirEntries:     dw 0E0h
TotalSectors:       dw 2880
MediaDescType:      db 0F0h
SectorsPerFAT:      dw 9
SectorsPerTrack:    dw 18
Heads:              dw 2

DriveNumber:        db 0