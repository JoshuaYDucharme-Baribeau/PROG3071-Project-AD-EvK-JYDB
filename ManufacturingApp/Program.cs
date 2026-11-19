/*
 * FILE             : Program.cs
 * PROJECT          : ADV SQL Project
 * PROGRAMMERS      : Deland, A.; Ducharme-Baribeau, J.; vanKooy, E.
 * FIRST VERSION    : November 19 2026
 * DESCRIPTION      : C# Source file for "Program.cs" containing "Program" class. Main entry for the ManufacturingApp application
 */

namespace ManufacturingApp
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Run applicationInstance = new Run();
            applicationInstance.InitializeApplication();
        }
    }
}
