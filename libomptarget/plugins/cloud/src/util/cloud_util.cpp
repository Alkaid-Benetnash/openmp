//===-------------------- Target RTLs Implementation -------------- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// RTL for Apache Spark cloud cluster
//
//===----------------------------------------------------------------------===//

#include <algorithm>
#include <array>
#include <cstdio>
#include <ctime>
#include <iostream>
#include <memory>
#include <stdexcept>
#include <string>

#include <dirent.h>
#include <ftw.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>

#include "cloud_util.h"

std::string exec_cmd(const char *cmd) {
  std::array<char, 128> buffer;
  std::string result;
  std::shared_ptr<FILE> pipe(popen(cmd, "r"), pclose);
  if (!pipe)
    throw std::runtime_error("popen() failed!");
  while (!feof(pipe.get())) {
    if (fgets(buffer.data(), 128, pipe.get()) != nullptr)
      result += buffer.data();
  }
  return result;
}

int32_t execute_command(const char *command, bool print_result,
                        bool print_cmd) {
  FILE *fp = popen(command, "r");

  if (print_cmd) {
    fprintf(stdout, "Running: %s\n", command);
  }

  if (fp == nullptr) {
    fprintf(stderr, "ERROR: Failed to execute command\n");
    return EXIT_FAILURE;
  }

  if (print_result) {
    char buf[512] = {0};
    size_t read = 0;

    while ((read = fread(buf, sizeof(char), size_t(511), fp)) == 512) {
      buf[511] = 0;
      fprintf(stdout, "%s", buf);
    }

    buf[read] = 0;
    fprintf(stdout, "%s", buf);
  }

  return pclose(fp);
}

std::string random_string(size_t length) {
  // Initialize pseudo random generator
  static bool isInit = false;
  if (!isInit) {
    srand(unsigned(time(nullptr)));
    isInit = true;
  }

  auto randchar = []() -> char {
    const char charset[] = "0123456789"
                           "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                           "abcdefghijklmnopqrstuvwxyz";
    const size_t max_index = (sizeof(charset) - 1);
    return charset[rand() % max_index];
  };
  std::string str(length, 0);
  std::generate_n(str.begin(), length, randchar);
  return str;
}

int remove_directory(const char *path) {
  DIR *d = opendir(path);
  size_t path_len = strlen(path);
  int r = -1;

  if (d) {
    struct dirent *p;

    r = 0;

    while (!r && (p = readdir(d))) {
      int r2 = -1;
      ;

      /* Skip the names "." and ".." as we don't want to recurse on them. */
      if (!strcmp(p->d_name, ".") || !strcmp(p->d_name, "..")) {
        continue;
      }

      size_t len = path_len + strlen(p->d_name) + 2;
      char *buf = new char[len];

      if (buf) {
        struct stat statbuf;

        snprintf(buf, len, "%s/%s", path, p->d_name);

        if (!stat(buf, &statbuf)) {
          if (S_ISDIR(statbuf.st_mode)) {
            r2 = remove_directory(buf);
          } else {
            r2 = unlink(buf);
          }
        }

        delete[] buf;
      }

      r = r2;
    }

    closedir(d);
  }

  if (!r) {
    r = rmdir(path);
  }

  return r;
}
