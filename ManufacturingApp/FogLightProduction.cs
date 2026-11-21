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
        internal void ManufactureFogLight(int amount)
        {
            try
            {
                using SqlConnection conn = new SqlConnection(_connectionString);
                using SqlCommand cmd = new SqlCommand("[FogLightManufacturing].[dbo].[ManufactureFogLights]", conn);
                cmd.CommandType = CommandType.StoredProcedure;


                // Create paramaters to pass between procedure and console app
                cmd.Parameters.AddWithValue("@Quantity", amount);
                var outputMessage = new SqlParameter("@ResultMessage", SqlDbType.VarChar, 100);
                outputMessage.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(outputMessage);

                conn.Open();
                cmd.ExecuteNonQuery();



                UserInterface.ManufacturingSuccess(outputMessage.Value?.ToString() ?? ""); // display the output message as a string

            }
            catch (SqlException ex)
            {
                UserInterface.ManufacturingError(ex.Message);
            }
            return;
        }

        internal void Addparts()
        {
            try
            {
                using SqlConnection conn = new SqlConnection(_connectionString);
                using SqlCommand cmd = new SqlCommand("[FogLightmanufacturing].[dbo].[Restock]", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                // Params to pass between app & procedure
                var outputMessage = new SqlParameter("@ResultMessage", SqlDbType.VarChar, 100);
                outputMessage.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(outputMessage);

                conn.Open();
                cmd.ExecuteNonQuery();

                UserInterface.ManufacturingSuccess(outputMessage.Value?.ToString() ?? ""); // Some string
            }
            catch (SqlException ex)
            {
                UserInterface.ManufacturingError(ex.Message);
            }
            return;
        }
    }
}
