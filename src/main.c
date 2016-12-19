#include <efi/efi.h>
#include <efilib.h>
#include <efiprot.h>

EFI_STATUS
efi_main(EFI_HANDLE ImageHandle, EFI_SYSTEM_TABLE *SystemTable) {
    InitializeLib(ImageHandle, SystemTable);
    Print(L"Hello, EFI-world!\n");
    return EFI_SUCCESS;
}
