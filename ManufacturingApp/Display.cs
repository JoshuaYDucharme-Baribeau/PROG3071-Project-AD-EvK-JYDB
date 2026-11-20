using System;
using System.Data;
using Microsoft.Data.SqlClient;

namespace ManufacturingApp
{
	internal class Display
	{
        const string _connectionString =
            "Server=localhost;Database=FogLightManufacturing;" +
            "Trusted_Connection=True;TrustServerCertificate=True;";
        internal void DisplayProdSum()
		{
            try
            {
                using SqlConnection conn = new SqlConnection(_connectionString);
                using SqlCommand cmd = new SqlCommand("[FogLightmanufacturing].[dbo].[ProductionSummary]", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                // Params to pass between procedure and app
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

		internal void DisplayLogs()
		{
            try
            {
                using SqlConnection conn = new SqlConnection(_connectionString);
                using SqlCommand cmd = new SqlCommand("[FogLightmanufacturing].[dbo].[ManufacuringLogs]", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                // Params to pass between procedure and app
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
