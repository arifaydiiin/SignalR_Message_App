using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace SignalR_project_for_Flutter
{
    public interface IHubMethods
    {
        Task ListUsersToClient(List<Users> clients);
        Task MesajlariAl(List<Chats> clients);
    }
}
