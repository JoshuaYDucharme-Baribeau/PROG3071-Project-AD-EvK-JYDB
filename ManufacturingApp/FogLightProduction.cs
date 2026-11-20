using System;
using System.Data;
using Microsoft.Data.SqlClient;

namespace ManufacturingApp
{
    internal class FogLightProduction
    {
        const string _connectionString = 
            "Server=localhost;Database=FogLightManufacturing;" +
            "Trusted_Connection=True;TrustServerCertificate=True;";
        internal bool ManufactureFogLight(int amount)
        {
            bool result = false;
        
            try
            {
                using SqlConnection conn = new SqlConnection(_connectionString);
                using SqlCommand cmd = new SqlCommand("[FogLightManufacturing].[dbo].[ManufactureFogLights]", conn);
                cmd.CommandType = CommandType.StoredProcedure;


                //create paramaters to pass between procedure and console app
                cmd.Parameters.AddWithValue("@Quantity", amount);
                var outputMessage = new SqlParameter("@ResultMessage", SqlDbType.VarChar, 100);
                outputMessage.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(outputMessage);

                conn.Open();
                cmd.ExecuteNonQuery();



                UserInterface.ManufacturingSuccess(outputMessage.Value?.ToString() ?? ""); // display the output message as a string

                result = true;
            }
            catch (SqlException ex)
            {
                UserInterface.ManufacturingError(ex.Message);
                result = false;
            }
            return result;
        }

        internal void Addparts()
        {
            try
            {
                using SqlConnection conn = new SqlConnection(_connectionString);
                using SqlCommand cmd = new SqlCommand("dbo.Restock", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                conn.Open();
                cmd.ExecuteNonQuery();

                UserInterface.ManufacturingSuccess(""); // Some string
            }
            catch (SqlException ex)
            {
                UserInterface.ManufacturingError(ex.Message);
            }
            return;
        }


    }
}
