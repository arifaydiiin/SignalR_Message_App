using Microsoft.AspNetCore.SignalR;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace SignalR_project_for_Flutter
{
    public class FlutterHub : Hub<IHubMethods>
    {

        static List<Users> clients = new List<Users>();
        static List<Chats> chats = new List<Chats>();
  
        public async Task AddUser(string userName)
        {
            Users user = new Users();
            user.connectionId = Context.ConnectionId;
            user.userName = userName;
            clients.Add(user);
            await Clients.All.ListUsersToClient(clients);
        }
        public async Task ListUsers()
        {
            await Clients.All.ListUsersToClient(clients);
        }

        public async Task MesajGonder(string mesajGidecekKisininUserName,string message)
        {
            var user = clients.FirstOrDefault(x => x.userName == mesajGidecekKisininUserName);
            Chats chat = new Chats {
                message = message,
                aliciUserName = mesajGidecekKisininUserName,
                vericiUserName = clients.FirstOrDefault(x => x.connectionId == Context.ConnectionId).userName,
            };
            chats.Add(chat);

            List<string> connectionIds = new List<string>();
            var mesajlar =  chats.Where(x => x.aliciUserName == chat.aliciUserName || x.aliciUserName == chat.vericiUserName).ToList();
            foreach (var item in mesajlar)
            {
                var aliciConnectionId = clients.SingleOrDefault(x => x.userName == item.aliciUserName).connectionId;
                var vericiConnectionId = clients.SingleOrDefault(x => x.userName == item.vericiUserName).connectionId;
                connectionIds.Add(aliciConnectionId);
                connectionIds.Add(vericiConnectionId);
                connectionIds.Distinct();
            }
            await Clients.Clients(connectionIds).MesajlariAl(mesajlar);
        }

        public async Task TumMesajlariAl(string aliciUserName, string vericiUserName)
        {
            var mesajlar = chats.Where(x => x.aliciUserName == aliciUserName || x.aliciUserName == vericiUserName).ToList();
            await Clients.Client(Context.ConnectionId).MesajlariAl(mesajlar);
        }
     
    }
}
