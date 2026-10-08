// JP TERMINAL - launcher para empacotamento MSIX / Microsoft Store
// Criado por Joaquim Pedro de Morais Filho - j360074@hotmail.com
// Abre o console real do JP TERMINAL (jpterm-console.ps1) que fica
// ao lado deste executavel dentro do pacote.
using System;
using System.Diagnostics;
using System.IO;
using System.Reflection;

class JPTerminal
{
    static void Main()
    {
        string dir = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
        string script = Path.Combine(dir, "jpterm-console.ps1");
        var psi = new ProcessStartInfo("powershell.exe",
            "-NoExit -NoProfile -ExecutionPolicy Bypass -File \"" + script + "\"");
        psi.UseShellExecute = true;
        try { Process.Start(psi); }
        catch (Exception ex)
        {
            Console.WriteLine("Falha ao iniciar o JP TERMINAL: " + ex.Message);
        }
    }
}
