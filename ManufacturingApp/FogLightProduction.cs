using System;
using System.Data;
using Microsoft.Data.SqlClient;

namespace ManufacturingApp
{
    internal class FogLightProduction
    {
        public bool ManufactureFogLight()
        {
            SqlConnection conn = null;
            SqlCommand cmd = null;

            try
            {
                conn = new SqlConnection(DBConnector._connectionString);
                cmd = new SqlCommand("dbo.ManufactureFogLight", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                conn.Open();
                cmd.ExecuteNonQuery();

                UserInterface.ManufacturingSuccess(""); // Some string

                return true;
            }
            catch (SqlException ex)
            {
                UserInterface.ManufacturingError("", ex.Message);
                return false;
            }
            finally
            {
                if (cmd != null)
                {
                    cmd.Dispose();
                }
                if (conn != null)
                {
                    if (conn.State != ConnectionState.Closed)
                    {
                        conn.Close();
                    }
                    conn.Dispose();
                }    
            }
        }
    }
}
