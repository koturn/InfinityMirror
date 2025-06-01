using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using UnityEditor;
using UnityEngine;


namespace Koturn.InfinityMirror
{
    /// <summary>
    /// Startup method provider.
    /// </summary>
    internal static class Startup
    {
        /// <summary>
        /// Pair of destination file GUID and source file GUID array.
        /// </summary>
        private static Dictionary<string, string[]> _includeResolverDefinition = new Dictionary<string, string[]>()
        {
            {
                // Assets/koturn/InfinityMirror/Shaders/include/LightVolumes.cginc
                "67a8194ec965d5a41a58b604ce2078f6", new string[]
                {
                    // Packages/red.sim.lightvolumes/Shaders/LightVolumes.cginc
                    "4ae0b01e695ad7545a078e1e04d2e609",
                    // Assets/koturn/InfinityMirror/Shaders/include/AltLightVolumes.cginc
                    "3d81bd8bdaaf1034f81705f2244d21e7"
                }
            }
        };

        /// <summary>
        /// A method called at Unity startup.
        /// </summary>
        [InitializeOnLoadMethod]
#pragma warning disable IDE0051 // Remove unused private members
        private static void OnStartup()
#pragma warning restore IDE0051 // Remove unused private members
        {
            AssetDatabase.importPackageCompleted += Startup_ImportPackageCompleted;
            UpdateIncludeFiles();
        }

        /// <summary>
        /// Update include files of shaders.
        /// </summary>
        [MenuItem("Assets/koturn/InfinityMirror/Regenerate include files", false, 9000)]
        private static void UpdateIncludeFiles()
        {
            foreach (var kv in _includeResolverDefinition)
            {
                var dstFilePath = AssetDatabase.GUIDToAssetPath(kv.Key);
                if (dstFilePath.Length == 0)
                {
                    throw new InvalidDataException("Cannot find file corresponding to GUID: " + kv.Key);
                }

                foreach (var srcGuid in kv.Value)
                {
                    var srcFilePath = AssetDatabase.GUIDToAssetPath(srcGuid);
                    if (srcFilePath.Length > 0)
                    {
                        UpdateIncludeResolverFile(dstFilePath, srcFilePath);
                        break;
                    }
                }
            }
        }

        /// <summary>
        /// A callback method for <see cref="AssetDatabase.importPackageCompleted"/>.
        /// </summary>
        /// <param name="packageName">Imported package name.</param>
        private static void Startup_ImportPackageCompleted(string packageName)
        {
            if (packageName != "InfinityMirror")
            {
                return;
            }
            UpdateIncludeFiles();
        }

        /// <summary>
        /// Update include resolver file.
        /// </summary>
        /// <param name="dstFilePath">Destination file path.</param>
        /// <param name="srcFilePath">Source file path path.</param>
        /// <param name="bufferSize">Buffer size for temporary buffer and <see cref="FileStream"/>,
        /// and initial capacity of <see cref="MemoryStream"/>.</param>
        /// <returns>Null if not updated, otherwise updated file path.</returns>
        private static string UpdateIncludeResolverFile(string dstFilePath, string srcFilePath, int bufferSize = 256)
        {
            using (var ms = new MemoryStream(bufferSize))
            {
                WriteIncludeResolverFileBytes(ms, srcFilePath, bufferSize);
                var buffer = ms.GetBuffer();
                var length = (int)ms.Length;

                if (CompareFileBytes(dstFilePath, buffer, 0, length, bufferSize))
                {
                    return null;
                }

                WriteBytes(dstFilePath, buffer, 0, length, bufferSize);

                return dstFilePath;
            }
        }

        /// <summary>
        /// Write include resolver file content to <see cref="s"/>.
        /// </summary>
        /// <param name="s">Destination stream.</param>
        /// <param name="assetPath">Asset path of include file.</param>
        /// <param name="bufferSize">Buffer size for <see cref="StreamWriter"/>.</param>
        private static void WriteIncludeResolverFileBytes(Stream stream, string assetPath, int bufferSize = 256)
        {
            using (var writer = new StreamWriter(stream, Encoding.ASCII, bufferSize, true)
            {
                NewLine = "\n"
            })
            {
                writer.WriteLine("#include \"{0}\"", assetPath);
            }
        }

        /// <summary>
        /// Write data to file.
        /// </summary>
        /// <param name="filePath">Destination file.</param>
        /// <param name="data">Data to write.</param>
        /// <param name="offset">Offset of data.</param>
        /// <param name="count">Number of Bytes to write.</param>
        /// <param name="bufferSize">Buffer size for <see cref="FileStream"/></param>
        private static void WriteBytes(string filePath, byte[] data, int offset, int count, int bufferSize = 4096)
        {
            using (var fs = new FileStream(filePath, FileMode.Create, FileAccess.Write, FileShare.Read, bufferSize))
            {
                fs.Write(data, offset, count);
            }
        }

        /// <summary>
        /// Compare file content with specified byte sequence.
        /// </summary>
        /// <param name="filePath">Target file path.</param>
        /// <param name="contentData">File content data to compare.</param>
        /// <param name="offset">Offset of <paramref name="contentData"/>,</param>
        /// <param name="length">Length of <paramref name="contentData"/>.</param>
        /// <param name="bufferSize">Buffer size for temporary buffer and <see cref="FileStream"/>.</param>
        /// <returns>True if file content is same to <paramref name="contentData"/>, otherwise false.</returns>
        private static bool CompareFileBytes(string filePath, byte[] contentData, int offset, int length, int bufferSize = 1024)
        {
            if (!File.Exists(filePath))
            {
                return false;
            }
            if (new FileInfo(filePath).Length != length)
            {
                return false;
            }

            var minBufferSize = Math.Min(length, bufferSize);
            using (var fs = new FileStream(filePath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite, minBufferSize, FileOptions.SequentialScan))
            {
                var buffer = new byte[minBufferSize];
                int nRead;
                while ((nRead = fs.Read(buffer, 0, buffer.Length)) > 0)
                {
                    if (!CompareMemory(buffer, 0, contentData, offset, nRead))
                    {
                        return false;
                    }
                    offset += nRead;
                }
            }

            return true;
        }

        /// <summary>
        /// Compare two byte data.
        /// </summary>
        /// <param name="data1">First byte data array.</param>
        /// <param name="offset1">Offset of first byte data array.</param>
        /// <param name="data2">Second byte data array.</param>
        /// <param name="offset2">Offset of second byte data array.</param>
        /// <param name="count">Number of bytes comparing <paramref name="data1"/> and <paramref name="data2"/>.</param>
        /// <returns>True if two byte data is same, otherwise false.</returns>
        private static bool CompareMemory(byte[] data1, int offset1, byte[] data2, int offset2, int count)
        {
            if (Environment.Is64BitProcess)
            {
                return CompareMemoryX64(data1, offset1, data2, offset2, count);
            }
            else
            {
                return CompareMemoryX86(data1, offset1, data2, offset2, count);
            }
        }

        /// <summary>
        /// Compare two byte data for x64 environment.
        /// </summary>
        /// <param name="data1">First byte data array.</param>
        /// <param name="offset1">Offset of first byte data array.</param>
        /// <param name="data2">Second byte data array.</param>
        /// <param name="offset2">Offset of second byte data array.</param>
        /// <param name="count">Number of bytes comparing <paramref name="data1"/> and <paramref name="data2"/>.</param>
        /// <returns>True if two byte data is same, otherwise false.</returns>
        private static bool CompareMemoryX64(byte[] data1, int offset1, byte[] data2, int offset2, int count)
        {
            unsafe
            {
                fixed (byte* pData1 = &data1[offset1])
                fixed (byte* pData2 = &data2[offset2])
                {
                    return CompareMemoryX64(pData1, pData2, (ulong)count);
                }
            }
        }

        /// <summary>
        /// Compare two byte data for x64 environment.
        /// </summary>
        /// <param name="pData1">First pointer to byte data array.</param>
        /// <param name="pData2">Second pointer to byte data array.</param>
        /// <param name="count">Number of bytes comparing <paramref name="pData1"/> and <paramref name="pData2"/>.</param>
        /// <returns>True if two byte data is same, otherwise false.</returns>
        private static unsafe bool CompareMemoryX64(byte* pData1, byte* pData2, ulong count)
        {
            const ulong stride = sizeof(ulong);
            var n = count & ~(stride - 1);

            for (ulong i = 0; i < n; i += stride)
            {
                if (*(ulong*)&pData1[i] != *(ulong*)&pData2[i])
                {
                    return false;
                }
            }

            for (ulong i = n; i < count; i++)
            {
                if (pData1[i] != pData2[i])
                {
                    return false;
                }
            }

            return true;
        }

        /// <summary>
        /// Compare two byte data for x86 environment.
        /// </summary>
        /// <param name="data1">First byte data array.</param>
        /// <param name="offset1">Offset of first byte data array.</param>
        /// <param name="data2">Second byte data array.</param>
        /// <param name="offset2">Offset of second byte data array.</param>
        /// <param name="count">Number of bytes comparing <paramref name="data1"/> and <paramref name="data2"/>.</param>
        /// <returns>True if two byte data is same, otherwise false.</returns>
        private static bool CompareMemoryX86(byte[] data1, int offset1, byte[] data2, int offset2, int count)
        {
            unsafe
            {
                fixed (byte* pData1 = &data1[offset1])
                fixed (byte* pData2 = &data2[offset2])
                {
                    return CompareMemoryX86(pData1, pData2, (uint)count);
                }
            }
        }

        /// <summary>
        /// Compare two byte data for x86 environment.
        /// </summary>
        /// <param name="pData1">First pointer to byte data array.</param>
        /// <param name="pData2">Second pointer to byte data array.</param>
        /// <param name="count">Number of bytes comparing <paramref name="pData1"/> and <paramref name="pData2"/>.</param>
        /// <returns>True if two byte data is same, otherwise false.</returns>
        private static unsafe bool CompareMemoryX86(byte* pData1, byte* pData2, uint count)
        {
            const uint stride = sizeof(uint);
            var n = count & ~(stride - 1);

            for (uint i = 0; i < n; i += stride)
            {
                if (*(uint*)&pData1[i] != *(uint*)&pData2[i])
                {
                    return false;
                }
            }

            for (uint i = n; i < count; i++)
            {
                if (pData1[i] != pData2[i])
                {
                    return false;
                }
            }

            return true;
        }
    }
}
