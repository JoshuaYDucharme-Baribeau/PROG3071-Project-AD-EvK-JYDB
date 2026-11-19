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
            char user_input; //using the ConsoleKeyInfo object/struct to store the key stroke for menu input

            //Call method to connect the application to the DB


            //instantiate FogLightProduction Class
            FogLightProduction productionControl = new FogLightProduction();

            //Menu display loop and function calls here
            while(running)
            {
                try
                {
                    //note that display menu clears the entire console each time it is called.
                    //if this is undesired, comment out the clearscreen call in the Display_menu method
                    UserInterface.Display_menu();
                
                    user_input = Char.ToLower(Console.ReadKey().KeyChar);
                    switch(user_input)
                    {
                        case '1':
                            //call method to display inventory here.
                        
                            UserInterface.Block_program("Press any Key to return to the menu.");
                            break;

                        case '2':
                            try
                            {
                                productionControl.ManufactureFogLight();
                            }
                            catch (Exception)
                            {
                                throw;
                            }

                            UserInterface.Block_program("Press any Key to return to the menu.");
                        
                            break;

                        case '3':
                            for (int i = 0; i < 5; i++)
                            {
                                try
                                {
                                    productionControl.ManufactureFogLight();
                                }
                                catch (Exception)
                                {
                                    throw;
                                }
                            }
                        
                            UserInterface.Block_program("Press any Key to return to the menu.");
                            break;

                        case '4':
                            //call method here
                        
                            UserInterface.Block_program("Press any Key to return to the menu.");
                            break;

                        case '5':
                            //call method here
                        
                            UserInterface.Block_program("Press any Key to return to the menu.");
                            break;

                        case '6':
                            //call method here
                        
                            UserInterface.Block_program("Press any Key to return to the menu.");
                            break;

                        case '7':
                            //ask user for confirmation to exit
                            UserInterface.Clear_screen();
                            UserInterface.Display_message("Are you sure you want to exit (Y/N)?");
                            user_input = Char.ToLower(Console.ReadKey().KeyChar);

                            if (user_input == 'y')
                            {
                                running = false; //change the main menu flag and exit the loop
                                UserInterface.Clear_screen();
                            }
                            //if input is not Y or y
                            //else
                            //{
                            //    //do nothing to continue looping to the menu
                            //}
                            break;

                        default:
                            UserInterface.Display_message("\nInvalid selection. Choose an operation by pressing one of the listed digits.");
                            UserInterface.Block_program("Press any Key to return to the menu.");
                            break;
                    }
                }
                //add any specific exception catchers here

                //generic/unhandled exceptions catcher
                catch (Exception ex)
                {

                    UserInterface.Display_message($"\n\nAn unexpected error occurred.\n{ex.Message}\nThe application will now shutdown.");
                    UserInterface.Block_program();
                    running = false; //change the main menu flag and exit the loop
                }

            }

            return;
        }
    }
}
