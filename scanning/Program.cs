using System;
using System.Collections.Generic;
using System.IO;
using Newtonsoft.Json;
using scanning;

namespace scanning
{
    class Program
    {
        static void Main()
        {
            // JSON dosyasını oku
            string jsonText = File.ReadAllText("response.json");

            // JSON'dan nesne oluştur
            var response = JsonConvert.DeserializeObject<ApiResponse>(jsonText);

            // Fiş metnini saklamak için boş bir dize oluştur
            string receiptText = "";

            // Her bir satır için
            foreach (var line in response.Lines)
            {
                // Satırın koordinatlarını al
                var coordinates = line.Coordinates;

                // Satırın içeriğini al
                var content = line.Text;

                // Satırın metne ekleneceği konumu hesapla
                int x = (int)Math.Round(coordinates[0].X);
                int y = (int)Math.Round(coordinates[0].Y);

                // Metne satırı ekle
                receiptText += content + Environment.NewLine;

                // Metni ekrana yazdır
                Console.WriteLine($"{x}, {y}: {content}");
            }

            // Metni dosyaya yaz
            File.WriteAllText("receipt.txt", receiptText);
        }
    }

    // ApiResponse sınıfı, JSON'dan nesne oluşturmak için kullanılır
    public class ApiResponse
    {
        [JsonProperty("lines")]
        public List<Line> Lines { get; set; }
    }

    // Line sınıfı, fişin bir satırını temsil eder
    public class Line
    {
        [JsonProperty("coordinates")]
        public List<Coordinate> Coordinates { get; set; }

        [JsonProperty("text")]
        public string Text { get; set; }
    }

    // Coordinate sınıfı, satırın bir karakterinin koordinatlarını temsil eder
    public class Coordinate
    {
        [JsonProperty("x")]
        public double X { get; set; }

        [JsonProperty("y")]
        public double Y { get; set; }
    }
}


// SaaS hizmetinden gelen JSON yanıtını parse eder. 
//JSON yanıtındaki description ve koordinat bilgilerini okur ve bu bilgileri kullanarak fişteki metinleri çıkarır.
//Son olarak, fiş metinlerini bir dosyaya kaydeder.

//Burada, ApiResponse, Line ve Coordinate sınıflarını tanımladım ve JsonProperty özniteliği ile JSON'dan nesne oluşturmak için kullanıldı. 
//ApiResponse sınıfındaki Lines özelliği, Line sınıfındaki Coordinates ve Text özelliklerine erişim sağlar. 
//Coordinates özelliği, Coordinate sınıfındaki X ve Y özelliklerine erişir.
//Ayrıca, Line sınıfındaki Coordinates ve Text özelliklerine JsonProperty özniteliği ekledim.
//Bu, JSON dosyasındaki ilgili alanları eşleştirmeye yardımcı olur.
//Ayrıca, Environment.NewLine yerine sabit bir değer olan \n kullanarak fiş metnindeki her satırın sonuna bir yeni satır karakteri ekledim.