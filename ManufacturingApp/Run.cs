/*
 * FILE             : Run.cs
 * PROJECT          : ADV SQL Project
 * PROGRAMMERS      : Deland, A.; Ducharme-Baribeau, J.; vanKooy, E.
 * FIRST VERSION    : November 19 2026
 * DESCRIPTION      : C# Source file for "Run.cs" containing "Run" class. Main class for running the application's control logic
 */
namespace ManufacturingApp
{
    internal class Run
    {
        //Called by main to start the application
        public void InitializeApplication()
        {
            Boolean running = true; //flag for the menu loop, will terminate the loop when False
            ConsoleKey user_input; //using the ConsoleKeyInfo object/struct to store the key stroke for menu input

            //Menu display loop and function calls here
            while(running)
            {
                //note that display menu clears the entire console each time it is called.
                //if this is undesired, comment out the clearscreen call in the Display_menu method
                UserInterface.Display_menu();
                user_input = Console.ReadKey().Key;
                switch(user_input)
                {
                    case ConsoleKey.A:
                        //call method here
                        UserInterface.Display_message("\n\n<A>n option selected... Do option A code");
                        UserInterface.Block_program("Press any Key to return to the menu.");
                        break;

                        //call method here
                    case ConsoleKey.D:
                        UserInterface.Display_message("\n\n<D>iffferent option selected... Do option D code");
                        UserInterface.Block_program("Press any Key to return to the menu.");
                        break;

                    case ConsoleKey.X:

                        //ask user for confirmation to exit
                        UserInterface.Clear_screen();
                        UserInterface.Display_message("Are you sure you want to exit (Y/N)?");
                        user_input = Console.ReadKey().Key;

                        if (user_input == ConsoleKey.Y)
                        {
                            running = false; //change the main menu flag and exit the loop
                            UserInterface.Clear_screen();
                        }
                        // i.e. if input is not Y or y
                        //else
                        //{
                        //    //do nothing to continue looping to the menu
                        //}
                        break;

                    default:
                        UserInterface.Display_message("\nInvalid selection. Choose an operation based on the characters in brackets <>.");
                        UserInterface.Block_program("Press any Key to return to the menu.");
                        break;
                }
            }

            return;
        }
    }
}
