/*
 * FILE             : UserInterface.cs
 * PROJECT          : ADV SQL Project
 * PROGRAMMERS      : Deland, A.; Ducharme-Baribeau, J.; vanKooy, E.
 * FIRST VERSION    : November 19 2026
 * DESCRIPTION      : C# Source file for "UserInterface.cs" containing "UserInterface" class. class for controlling the console interface and displays
 */
namespace ManufacturingApp
{
    //static class so that it doesn't need to be instantiated
    static internal class UserInterface
    {

        /*
         * METHOD       : Display_menu
         * 
         * DESCRIPTION  : displays the main menu of the program
         * 
         * PARAMETERS   : NONE
         * 
         * RETURNS      : NOTHING
         */
        internal static void Display_menu()
        {
            Clear_screen(); //clear the screen before displaying anything

            //Main menu's WriteLine. Concatenated for code readability. Displays almost exactly as coded.
            Console.WriteLine
                (
                    "<A>n option\n" +
                    "<D>ifferent option\n" +
                    "E<X>it the program\n" +
                    "Please choose the operation you would like to perform:\n\n"
                );

            return;
        }

        /*
         * METHOD       : Clear_screen
         * 
         * DESCRIPTION  : clears the UI (i.e. clears the cli display).
         *                Although a method for this exists in the System namespace, 
         *                Might be used frequently so we can modify it's behaviour here 
         * 
         * PARAMETERS   : NONE
         * 
         * RETURNS      : NOTHING
         */
        internal static void Clear_screen()
        {
            Console.Clear();
            return;
        }

        /*
         * METHOD       : Block_program
         * 
         * DESCRIPTION  : displays a message and awaits for key input before continuing
         * 
         * PARAMETERS   : string message_prompt : a string that will be written to the console.
         * 
         * RETURNS      : NOTHING
         */
        internal static void Block_program(string message_prompt = "Press any key to continue...") //sets a default param to make the param optional.
        {
            Console.WriteLine(message_prompt);
            Console.ReadKey();
            return;
        }

        /*
         * METHOD       : Display_message
         * 
         * DESCRIPTION  : displays a regular message without blocking the program
         * 
         * PARAMETERS   : string message  : [OPTIONAL] A message that will be displayed. 
         *
         * 
         * RETURNS      : NOTHING
         */
        internal static void Display_message(string message = "No message to display.") //default message for debugging
        {
            Console.WriteLine(message);
            return;
        }
    }
}
