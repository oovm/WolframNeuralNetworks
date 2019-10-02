import torch
import wolframclient.serializers as wxf


def pth2wxf(path):
    pth = torch.load(path, map_location=torch.device('cpu'))
    npy = {key: value.numpy() for key, value in pth.items()}
    wxf.export(npy, path + '.wxf', target_format='wxf')


pth2wxf('netG_epoch_67.pth')
