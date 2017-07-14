using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Reflection;
using System.IO;
using System.Data.SqlClient;


namespace GetRemains
{
    class Program
    {
        static void Main(string[] args)
        {



           
            var assembly = Assembly.GetExecutingAssembly();
           
            
            String[] ResNames = assembly.GetManifestResourceNames();
            var resourceName = ResNames[0];

            using (Stream stream = assembly.GetManifestResourceStream(resourceName))
            using (TextReader reader = new StreamReader(stream)) 
            {
                
                String result = reader.ReadToEnd();
                result = result.Replace("!Contractor!", "Лукрум"); 
                using (SqlConnection connection = new SqlConnection(Properties.Settings.Default.ConnectionString))
                {
                    connection.Open();
                    ExportTable(connection, result, "remains.csv");

                }
            }

            
        }
        private static void ExportTable(SqlConnection connection, string tableName, string fName)
        {
            //fName = DateTime.Now.ToString("yyyy-MM-dd ") + "~" + Properties.Settings.Default.SubID + fName;
            fName = DateTime.Now.ToString() + "~" + Properties.Settings.Default.SubID + fName;

            String pPath = Directory.GetCurrentDirectory();
            if (Properties.Settings.Default.DestinationFolder.Length > 1)
            {
                pPath = Properties.Settings.Default.DestinationFolder;
            }
            fName = fName.Replace(" ", "-");
            fName = fName.Replace(":","-");


            Console.WriteLine("Writing " + fName);
            using (var output = new StreamWriter(Path.Combine(pPath, fName), false, Encoding.GetEncoding("Windows-1251"))) // добавить дату fname
            {
                using (var cmd = connection.CreateCommand())
                {
                    cmd.CommandText = tableName;// File.ReadAllText(tableName);
                    using (var reader = cmd.ExecuteReader())
                    {
                        WriteHeader(reader, output);
                        while (reader.Read())
                        {
                            WriteData(reader, output);
                        }
                    }
                }
            }
        }


        private static void WriteHeader(SqlDataReader reader, TextWriter output)
        {
            for (int i = 0; i < reader.FieldCount; i++)
            {
                if (i > 0)
                    output.Write(';');
                output.Write(reader.GetName(i));
            }
            output.Write(';');
            output.WriteLine();
        }

        private static void WriteData(SqlDataReader reader, TextWriter output)
        {
            for (int i = 0; i < reader.FieldCount; i++)
            {
                if (i > 0)
                    output.Write(';');
                String v = reader[i].ToString();
                if (reader[i].GetType().FullName == "System.Decimal")
                    v = v.Replace(",", ".");

                if (v.Contains(';') || v.Contains('\n') || v.Contains('\r') || v.Contains('"'))
                {
                    output.Write('"');
                    output.Write(v.Replace("\"", "\"\""));
                    output.Write('"');
                }
                else
                {

                    output.Write(v);
                }
            }
            output.Write(";");
            output.WriteLine();
        }
    }
}
