using Microsoft.AspNetCore.SignalR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace SignalR_First_Project
{
    public class FlutterHub:Hub
    {
        public async Task SendMessage(string message)
        {
            await Clients.All.SendAsync("receiveMessage", message);
        }
    }
}
